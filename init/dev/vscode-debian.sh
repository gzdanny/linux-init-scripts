#!/bin/bash
set -e

echo "=== Installing VSCode (Debian) ==="

# 安装依赖
sudo apt update -y
sudo apt install -y wget gpg

# 添加微软仓库
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# 更新索引并安装 VSCode
sudo apt update -y
sudo apt install -y code

echo "=== VSCode Installation Completed ==="
echo "Run 'code' to start VSCode"
