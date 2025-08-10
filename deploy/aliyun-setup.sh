#!/bin/bash

echo "========================================"
echo "阿里云服务器完整设置脚本"
echo "========================================"
echo

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
    echo "请使用 sudo 运行此脚本"
    exit 1
fi

# 更新系统
echo "正在更新系统..."
yum update -y

# 安装EPEL仓库（CentOS需要）
echo "正在安装EPEL仓库..."
yum install -y epel-release

# 安装Java环境（JDK 21）
echo "正在安装Java环境..."

# 对于CentOS 7，需要添加额外的仓库来安装JDK 21
if [ -f /etc/redhat-release ]; then
    CENTOS_VERSION=$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+' | head -1)
    if [[ "$CENTOS_VERSION" == "7"* ]]; then
        echo "检测到CentOS 7，安装JDK 21..."
        # 添加AdoptOpenJDK仓库
        yum install -y wget
        wget -O /etc/yum.repos.d/adoptium.repo https://packages.adoptium.net/artifactory/rpm/centos/7/x86_64/adoptium.repo
        yum install -y temurin-21-jdk
    else
        echo "检测到CentOS 8+，安装JDK 21..."
        # CentOS 8+ 可以直接安装
        yum install -y java-21-openjdk java-21-openjdk-devel
    fi
else
    echo "检测到其他RHEL系统，尝试安装JDK 21..."
    yum install -y java-21-openjdk java-21-openjdk-devel
fi

# 检查Java安装
java -version
if [ $? -ne 0 ]; then
    echo "Java安装失败，尝试备用方案..."
    # 备用方案：手动下载安装JDK 21
    cd /tmp
    wget https://download.java.net/java/GA/jdk21.0.2/13d5b2a4be90462f896e6f96bcf36db2/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz
    tar -xzf openjdk-21.0.2_linux-x64_bin.tar.gz
    mv jdk-21.0.2 /usr/local/
    
    # 设置环境变量
    echo 'export JAVA_HOME=/usr/local/jdk-21.0.2' >> /etc/profile
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile
    source /etc/profile
    
    # 创建软链接
    ln -sf /usr/local/jdk-21.0.2/bin/java /usr/bin/java
    ln -sf /usr/local/jdk-21.0.2/bin/javac /usr/bin/javac
    
    # 再次检查
    java -version
    if [ $? -ne 0 ]; then
        echo "Java安装完全失败"
        exit 1
    fi
fi

# 安装Nginx
echo "正在安装Nginx..."
yum install -y nginx

# 创建目录结构
echo "正在创建目录结构..."
mkdir -p /var/www/ai-agent-frontend
mkdir -p /opt/ai-agent
mkdir -p /var/log/ai-agent

# 设置权限（CentOS使用nginx用户）
echo "正在设置目录权限..."
chown -R nginx:nginx /var/www/ai-agent-frontend
chmod -R 755 /var/www/ai-agent-frontend
chown -R root:root /opt/ai-agent
chmod -R 755 /opt/ai-agent

# 创建后端服务配置文件
echo "正在创建后端服务配置..."
cat > /etc/systemd/system/ai-agent.service << 'EOF'
[Unit]
Description=AI Agent Backend Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/ai-agent
ExecStart=/usr/local/jdk-21.0.8/bin/java -jar AI-Agent-0.0.1-SNAPSHOT.jar
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# 配置Nginx（CentOS路径）
echo "正在配置Nginx..."
cat > /etc/nginx/conf.d/sigma429.online.conf << 'EOF'
server {
    listen 80;
    server_name sigma429.online;
    
    # 前端静态文件
    root /var/www/ai-agent-frontend/dist;
    index index.html;
    
    # 处理前端路由
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # 代理后端API请求
    location /api {
        proxy_pass http://localhost:8123;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # SSE支持
        proxy_buffering off;
        proxy_cache off;
        proxy_set_header Connection '';
        proxy_http_version 1.1;
        chunked_transfer_encoding off;
        
        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
}
EOF

# 启用网站配置（CentOS不需要sites-enabled）
echo "正在启用网站配置..."
# CentOS的Nginx配置直接在conf.d目录下生效

# 删除默认配置
rm -f /etc/nginx/conf.d/default.conf

# 测试Nginx配置
echo "正在测试Nginx配置..."
nginx -t

if [ $? -eq 0 ]; then
    echo "Nginx配置测试通过"
    echo "正在重启Nginx..."
    systemctl restart nginx
    systemctl enable nginx
else
    echo "Nginx配置测试失败"
    exit 1
fi

# 配置防火墙（CentOS使用firewalld）
echo "正在配置防火墙..."
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=8123/tcp
firewall-cmd --reload

# 重新加载systemd
systemctl daemon-reload

echo
echo "========================================"
echo "服务器设置完成！"
echo "========================================"
echo
echo "下一步操作："
echo "1. 上传前端文件: scp -r dist/ root@123.57.74.30:/var/www/ai-agent-frontend/"
echo "2. 上传后端JAR包: scp AI-Agent-0.0.1-SNAPSHOT.jar root@123.57.74.30:/opt/ai-agent/"
echo "3. 启动后端服务: sudo systemctl start ai-agent"
echo "4. 设置开机自启: sudo systemctl enable ai-agent"
echo "5. 配置域名解析到 123.57.74.30"
echo
echo "服务管理命令："
echo "启动后端: sudo systemctl start ai-agent"
echo "停止后端: sudo systemctl stop ai-agent"
echo "重启后端: sudo systemctl restart ai-agent"
echo "查看状态: sudo systemctl status ai-agent"
echo "查看日志: sudo journalctl -u ai-agent -f"
echo
echo "Nginx管理："
echo "重启Nginx: sudo systemctl restart nginx"
echo "查看状态: sudo systemctl status nginx"
echo "查看日志: sudo tail -f /var/log/nginx/error.log"
echo
echo "检查服务："
echo "检查端口: netstat -tlnp | grep -E ':(80|443|8123)'"
echo "检查进程: ps aux | grep -E '(java|nginx)'"
echo "检查防火墙: firewall-cmd --list-all"
echo
echo "========================================"

