#!/bin/bash
set -e

echo "=== Installing Android Studio (Debian) ==="

# 安装依赖
sudo apt update -y
sudo apt install -y openjdk-11-jdk wget unzip

# 下载 Android Studio
ANDROID_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/latest/android-studio-linux.tar.gz"
wget -O /tmp/android-studio.tar.gz $ANDROID_URL

# 安装到 /opt
sudo tar -xzf /tmp/android-studio.tar.gz -C /opt
rm /tmp/android-studio.tar.gz

# 创建快捷方式
sudo ln -s /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio

echo "=== Android Studio Installation Completed ==="
echo "Run 'android-studio' to start Android Studio"
