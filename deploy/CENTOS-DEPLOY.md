# CentOS 服务器部署指南

## 服务器信息
- **IP地址**: 123.57.74.30
- **域名**: sigma429.online
- **操作系统**: CentOS
- **后端JAR包**: AI-Agent-0.0.1-SNAPSHOT.jar

## 快速部署步骤

### 1. 本地构建前端
```bash
# 运行CentOS专用构建脚本
./deploy-centos.sh
```

### 2. 服务器端设置
```bash
# 上传设置脚本到服务器
scp aliyun-setup.sh root@123.57.74.30:/tmp/

# 连接到服务器并运行设置脚本
ssh root@123.57.74.30
sudo bash /tmp/aliyun-setup.sh
```

### 3. 上传文件到服务器
```bash
# 上传前端文件
scp -r dist/ root@123.57.74.30:/var/www/ai-agent-frontend/

# 上传后端JAR包
scp AI-Agent-0.0.1-SNAPSHOT.jar root@123.57.74.30:/opt/ai-agent/
```

### 4. 启动服务
```bash
# 启动后端服务
sudo systemctl start ai-agent
sudo systemctl enable ai-agent

# 重启Nginx
sudo systemctl restart nginx
```

### 5. 检查服务状态
```bash
# 检查服务状态
sudo systemctl status ai-agent
sudo systemctl status nginx

# 检查端口监听
netstat -tlnp | grep -E ":(80|443|8123)"

# 检查防火墙
firewall-cmd --list-all
```

## 服务器管理

### 上传管理脚本
```bash
scp centos-manager.sh root@123.57.74.30:/usr/local/bin/
chmod +x /usr/local/bin/centos-manager.sh
```

### 常用管理命令
```bash
# 查看服务状态
centos-manager status

# 重启所有服务
centos-manager restart

# 查看后端日志
centos-manager logs

# 系统监控
centos-manager monitor

# 防火墙管理
centos-manager firewall status
```

## CentOS 特有配置

### 包管理器
- 使用 `yum` 而不是 `apt`
- 需要安装 `epel-release` 仓库
- Java包名: `java-21-openjdk` (JDK 21)
- CentOS 7需要额外仓库支持JDK 21

### 防火墙
- 使用 `firewalld` 而不是 `ufw`
- 命令: `firewall-cmd --permanent --add-port=端口/tcp`

### Nginx配置
- 配置文件路径: `/etc/nginx/conf.d/`
- 用户: `nginx` 而不是 `www-data`
- 不需要 `sites-enabled` 目录

### 服务管理
- 使用 `systemctl` 管理服务
- 服务配置文件: `/etc/systemd/system/ai-agent.service`

## 目录结构
```
/var/www/ai-agent-frontend/dist/     # 前端文件
/opt/ai-agent/AI-Agent-0.0.1-SNAPSHOT.jar  # 后端JAR包
/etc/nginx/conf.d/sigma429.online.conf      # Nginx配置
/etc/systemd/system/ai-agent.service        # 后端服务配置
/var/log/ai-agent/                          # 后端日志目录
```

## 访问地址
- **域名访问**: https://sigma429.online
- **IP访问**: http://123.57.74.30
- **后端API**: http://123.57.74.30:8123

## 故障排除

### 常见问题
1. **Java版本问题**: 确保安装Java 21
2. **防火墙问题**: 检查firewalld状态和端口开放
3. **权限问题**: 确保nginx用户有访问权限
4. **SELinux问题**: 可能需要配置SELinux策略
5. **CentOS 7 JDK 21**: 需要额外仓库支持

### 检查命令
```bash
# 检查Java版本
java -version

# 检查JAVA_HOME环境变量
echo $JAVA_HOME

# 检查防火墙状态
firewall-cmd --list-all

# 检查SELinux状态
getenforce

# 检查服务状态
systemctl status ai-agent nginx

# 查看日志
journalctl -u ai-agent -f
tail -f /var/log/nginx/error.log
```

## 更新部署

### 更新前端
```bash
# 本地构建
./deploy-centos.sh

# 上传到服务器
scp -r dist/ root@123.57.74.30:/tmp/

# 在服务器上更新
sudo centos-manager.sh update-frontend
```

### 更新后端
```bash
# 上传JAR包
scp AI-Agent-0.0.1-SNAPSHOT.jar root@123.57.74.30:/tmp/

# 在服务器上更新
sudo centos-manager.sh update-backend
```

## 备份和恢复

### 备份
```bash
sudo centos-manager.sh backup
```

### 恢复
```bash
# 从备份目录恢复文件
sudo cp /backup/时间戳/* /相应目录/
sudo systemctl restart ai-agent nginx
```
