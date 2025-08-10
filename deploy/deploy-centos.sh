#!/bin/bash

echo "========================================"
echo "AI Agent CentOS 服务器快速部署脚本"
echo "========================================"
echo

# 检查是否在项目根目录
if [ ! -f "package.json" ]; then
    echo "错误: 请在项目根目录运行此脚本"
    exit 1
fi

echo "正在检查Node.js..."
if ! command -v node &> /dev/null; then
    echo "错误: 未找到Node.js，请先安装Node.js"
    exit 1
fi

echo "Node.js版本: $(node --version)"

echo
echo "正在安装前端依赖..."
npm install

if [ $? -ne 0 ]; then
    echo "前端依赖安装失败"
    exit 1
fi

echo
echo "正在构建前端生产版本..."
npm run build

if [ $? -ne 0 ]; then
    echo "前端构建失败，请检查错误信息"
    exit 1
fi

echo
echo "========================================"
echo "前端构建完成！"
echo "========================================"
echo
echo "CentOS服务器部署信息："
echo "域名: https://sigma429.online"
echo "IP地址: http://123.57.74.30"
echo "后端JAR包: AI-Agent-0.0.1-SNAPSHOT.jar"
echo "操作系统: CentOS"
echo
echo "快速部署步骤："
echo "1. 上传设置脚本到服务器"
echo "2. 在服务器上运行设置脚本"
echo "3. 上传前端文件到服务器"
echo "4. 上传后端JAR包到服务器"
echo "5. 启动服务"
echo
echo "执行以下命令："
echo
echo "# 1. 上传设置脚本"
echo "scp aliyun-setup.sh root@123.57.74.30:/tmp/"
echo
echo "# 2. 在服务器上运行设置脚本"
echo "ssh root@123.57.74.30"
echo "sudo bash /tmp/aliyun-setup.sh"
echo
echo "# 3. 上传前端文件"
echo "scp -r dist/ root@123.57.74.30:/var/www/ai-agent-frontend/"
echo
echo "# 4. 上传后端JAR包"
echo "scp AI-Agent-0.0.1-SNAPSHOT.jar root@123.57.74.30:/opt/ai-agent/"
echo
echo "# 5. 启动服务"
echo "sudo systemctl start ai-agent"
echo "sudo systemctl enable ai-agent"
echo "sudo systemctl restart nginx"
echo
echo "# 6. 检查服务状态"
echo "sudo systemctl status ai-agent"
echo "sudo systemctl status nginx"
echo "firewall-cmd --list-all"
echo
echo "========================================"
