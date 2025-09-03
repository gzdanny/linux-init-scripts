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

# 创建动态 motd 脚本，htop风格配色
sudo tee /etc/update-motd.d/99-system-info > /dev/null <<'EOF'
#!/bin/bash

# 配色定义（htop 风格）
TITLE="\033[1;36m"   # 粗体亮青
LABEL="\033[0;37m"   # 灰白
VALUE="\033[1;32m"   # 亮绿
WARN="\033[1;33m"    # 黄色
ALERT="\033[1;31m"   # 红色
RESET="\033[0m"

# Linux 发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$NAME $VERSION"
else
    DISTRO="Unknown Linux"
fi

# IP
IP_ADDR=$(hostname -I | awk '{print $1}')

# CPU
CPU_MODEL=$(lscpu | grep "Model name" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')

# 根据 1 分钟负载选择颜色
LOAD1=$(echo $CPU_LOAD | awk -F, '{print $1}')
LOAD_COLOR=$VALUE
if (( $(echo "$LOAD1 > 1.0" | bc -l) )); then
    LOAD_COLOR=$WARN
fi
if (( $(echo "$LOAD1 > 2.0" | bc -l) )); then
    LOAD_COLOR=$ALERT
fi

# 内存
MEM_INFO=$(free -h | awk '/Mem:/ {print "Used: "$3", Free: "$4}')

# 输出彩色信息
echo -e "${TITLE}=== System Info ===${RESET}"
echo -e "${LABEL}Distro: ${VALUE}${DISTRO}${RESET}"
echo -e "${LABEL}IP Address: ${VALUE}${IP_ADDR}${RESET}"
echo -e "${LABEL}CPU: ${VALUE}${CPU_MODEL}${LABEL} | Load: ${LOAD_COLOR}${CPU_LOAD}${RESET}"
echo -e "${LABEL}Memory: ${VALUE}${MEM_INFO}${RESET}"
EOF

sudo chmod +x /etc/update-motd.d/99-system-info

# 可选：刷新 /etc/issue 每分钟，htop风格配色
ISSUE_SCRIPT="/usr/local/bin/update-issue.sh"
sudo tee "$ISSUE_SCRIPT" > /dev/null <<'EOF'
#!/bin/bash

# 配色定义
TITLE="\033[1;36m"
LABEL="\033[0;37m"
VALUE="\033[1;32m"
WARN="\033[1;33m"
ALERT="\033[1;31m"
RESET="\033[0m"

# Linux 发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$NAME $VERSION"
else
    DISTRO="Unknown Linux"
fi

# IP
IP_ADDR=$(hostname -I | awk '{print $1}')

# CPU
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')
LOAD1=$(echo $CPU_LOAD | awk -F, '{print $1}')
LOAD_COLOR=$VALUE
if (( $(echo "$LOAD1 > 1.0" | bc -l) )); then
    LOAD_COLOR=$WARN
fi
if (( $(echo "$LOAD1 > 2.0" | bc -l) )); then
    LOAD_COLOR=$ALERT
fi

# 内存
MEM_INFO=$(free -h | awk '/Mem:/ {print "Used: "$3", Free: "$4}')

# 输出到 /etc/issue
echo -e "${TITLE}=== System Info ===${RESET}\n${LABEL}Distro: ${VALUE}${DISTRO}${RESET}\n${LABEL}IP Address: ${VALUE}${IP_ADDR}${RESET}\n${LABEL}CPU Load: ${LOAD_COLOR}${CPU_LOAD}${RESET}\n${LABEL}Memory: ${VALUE}${MEM_INFO}${RESET}" > /etc/issue
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
echo "Login via SSH or TTY to see updated system info with htop-style colors and distro info"
