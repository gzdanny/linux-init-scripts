#!/bin/bash
set -e

echo "=== Enhance Login Interface (Extended Info) ==="

ISSUE_FILE="/etc/issue"

BLOCK=$(cat <<'EOF'
Date: \d   Time: \t
IP: \4     Users: \U
Kernel: \r on \m
EOF
)

# 如果还没有，就追加
if ! grep -q "Date: " "$ISSUE_FILE"; then
    echo "$BLOCK" | sudo tee -a "$ISSUE_FILE" > /dev/null
    echo "已在 $ISSUE_FILE 添加系统信息块"
else
    echo "$ISSUE_FILE 已包含系统信息，无需修改"
fi

echo "=== Done. 重启或切换到 TTY 即可看到效果 ==="
