#!/bin/bash

echo "========================================"
echo "AI Agent CentOS 服务器管理脚本"
echo "========================================"
echo

case "$1" in
    "start")
        echo "正在启动所有服务..."
        systemctl start nginx
        systemctl start ai-agent
        echo "服务启动完成"
        ;;
    "stop")
        echo "正在停止所有服务..."
        systemctl stop ai-agent
        systemctl stop nginx
        echo "服务停止完成"
        ;;
    "restart")
        echo "正在重启所有服务..."
        systemctl restart nginx
        systemctl restart ai-agent
        echo "服务重启完成"
        ;;
    "status")
        echo "=== 服务状态 ==="
        echo "Nginx状态:"
        systemctl status nginx --no-pager -l
        echo
        echo "AI Agent后端状态:"
        systemctl status ai-agent --no-pager -l
        echo
        echo "=== 端口监听 ==="
        netstat -tlnp | grep -E ":(80|443|8123)"
        echo
        echo "=== 进程状态 ==="
        ps aux | grep -E "(java|nginx)" | grep -v grep
        echo
        echo "=== 防火墙状态 ==="
        firewall-cmd --list-all
        ;;
    "logs")
        echo "=== 后端日志 ==="
        journalctl -u ai-agent -f
        ;;
    "nginx-logs")
        echo "=== Nginx访问日志 ==="
        tail -f /var/log/nginx/access.log
        ;;
    "nginx-error")
        echo "=== Nginx错误日志 ==="
        tail -f /var/log/nginx/error.log
        ;;
    "update-frontend")
        echo "正在更新前端文件..."
        if [ -d "/tmp/dist" ]; then
            rm -rf /var/www/ai-agent-frontend/dist
            mv /tmp/dist /var/www/ai-agent-frontend/
            chown -R nginx:nginx /var/www/ai-agent-frontend
            echo "前端更新完成"
        else
            echo "错误: 未找到 /tmp/dist 目录"
        fi
        ;;
    "update-backend")
        echo "正在更新后端服务..."
        if [ -f "/tmp/AI-Agent-0.0.1-SNAPSHOT.jar" ]; then
            systemctl stop ai-agent
            mv /tmp/AI-Agent-0.0.1-SNAPSHOT.jar /opt/ai-agent/
            systemctl start ai-agent
            echo "后端更新完成"
        else
            echo "错误: 未找到 /tmp/AI-Agent-0.0.1-SNAPSHOT.jar 文件"
        fi
        ;;
    "backup")
        echo "正在备份当前配置..."
        mkdir -p /backup/$(date +%Y%m%d_%H%M%S)
        cp -r /var/www/ai-agent-frontend /backup/$(date +%Y%m%d_%H%M%S)/
        cp /opt/ai-agent/AI-Agent-0.0.1-SNAPSHOT.jar /backup/$(date +%Y%m%d_%H%M%S)/
        cp /etc/nginx/conf.d/sigma429.online.conf /backup/$(date +%Y%m%d_%H%M%S)/
        echo "备份完成"
        ;;
    "monitor")
        echo "=== 系统监控 ==="
        echo "CPU使用率:"
        top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
        echo "内存使用:"
        free -h
        echo "磁盘使用:"
        df -h
        echo "网络连接:"
        netstat -an | grep :8123 | wc -l
        echo "个连接到后端"
        echo "防火墙状态:"
        firewall-cmd --list-all
        ;;
    "firewall")
        echo "=== 防火墙管理 ==="
        case "$2" in
            "status")
                firewall-cmd --list-all
                ;;
            "open")
                if [ -n "$3" ]; then
                    firewall-cmd --permanent --add-port=$3/tcp
                    firewall-cmd --reload
                    echo "端口 $3 已开放"
                else
                    echo "用法: $0 firewall open <端口号>"
                fi
                ;;
            "close")
                if [ -n "$3" ]; then
                    firewall-cmd --permanent --remove-port=$3/tcp
                    firewall-cmd --reload
                    echo "端口 $3 已关闭"
                else
                    echo "用法: $0 firewall close <端口号>"
                fi
                ;;
            *)
                echo "防火墙命令:"
                echo "  status - 查看防火墙状态"
                echo "  open <端口> - 开放端口"
                echo "  close <端口> - 关闭端口"
                ;;
        esac
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status|logs|nginx-logs|nginx-error|update-frontend|update-backend|backup|monitor|firewall}"
        echo
        echo "命令说明:"
        echo "  start          - 启动所有服务"
        echo "  stop           - 停止所有服务"
        echo "  restart        - 重启所有服务"
        echo "  status         - 查看服务状态"
        echo "  logs           - 查看后端日志"
        echo "  nginx-logs     - 查看Nginx访问日志"
        echo "  nginx-error    - 查看Nginx错误日志"
        echo "  update-frontend - 更新前端文件"
        echo "  update-backend  - 更新后端JAR包"
        echo "  backup         - 备份当前配置"
        echo "  monitor        - 系统监控"
        echo "  firewall       - 防火墙管理"
        echo
        echo "防火墙命令:"
        echo "  $0 firewall status    - 查看防火墙状态"
        echo "  $0 firewall open 8080 - 开放8080端口"
        echo "  $0 firewall close 8080 - 关闭8080端口"
        ;;
esac
