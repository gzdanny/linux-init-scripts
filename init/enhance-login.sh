#!/bin/bash
set -e

echo "=== Enhance Login Interface ==="

# 检测系统
OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        debian) OS="debian" ;;
        ubuntu) OS="ubuntu" ;;
        centos) OS="centos" ;;
        rocky) OS="rocky" ;;
        *) echo "Unsupported OS"; exit 1 ;;
    esac
else
    echo "Unsupported OS"
    exit 1
fi

# 安装必要工具
install_pkg() {
    if [[ "$OS" == "debian" || "$OS" == "ubuntu" ]]; then
        sudo apt update -y
        sudo apt install -y lsb-release procps net-tools
    else
        if command -v dnf &>/dev/null; then
            sudo dnf install -y procps-ng net-tools
        else
            sudo yum install -y procps net-tools
        fi
    fi
}

install_pkg

# 创建动态 motd 脚本
sudo tee /etc/update-motd.d/99-system-info > /dev/null <<'EOF'
#!/bin/bash
IP_ADDR=$(hostname -I | awk '{print $1}')
CPU_MODEL=$(lscpu | grep "Model name" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')
MEM_INFO=$(free -h | awk '/Mem:/ {print "Used: "$3", Free: "$4}')
echo "=== System Info ==="
echo "IP Address: $IP_ADDR"
echo "CPU: $CPU_MODEL | Load: $CPU_LOAD"
echo "Memory: $MEM_INFO"
EOF

sudo chmod +x /etc/update-motd.d/99-system-info

# 可选：刷新 /etc/issue 每分钟
ISSUE_SCRIPT="/usr/local/bin/update-issue.sh"
sudo tee "$ISSUE_SCRIPT" > /dev/null <<'EOF'
#!/bin/bash
IP_ADDR=$(hostname -I | awk '{print $1}')
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')
MEM_INFO=$(free -h | awk '/Mem:/ {print "Used: "$3", Free: "$4}')
echo -e "IP Address: $IP_ADDR\nCPU Load: $CPU_LOAD\nMemory: $MEM_INFO" > /etc/issue
EOF

sudo chmod +x "$ISSUE_SCRIPT"

# 设置 systemd timer，每分钟更新 /etc/issue
sudo tee /etc/systemd/system/update-issue.service > /dev/null <<EOF
[Unit]
Description=Update /etc/issue with system info

[Service]
Type=oneshot
ExecStart=$ISSUE_SCRIPT
EOF

sudo tee /etc/systemd/system/update-issue.timer > /dev/null <<EOF
[Unit]
Description=Run update-issue.service every minute

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=update-issue.service

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now update-issue.timer

echo "=== Enhance Login Interface Installed ==="
echo "Login via SSH or TTY to see updated system info"
