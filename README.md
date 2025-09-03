# Linux Init Scripts 🚀

A collection of Linux initialization scripts for quickly setting up servers on Debian, Ubuntu, CentOS, and Rocky Linux.

## Features
- 🐧 **Multi-Distribution Support**: Debian/Ubuntu and CentOS/Rocky  
- ⚡ **One Command Setup**: Install SSH, sudo, firewall automatically  
- 🔒 **Basic Security**: SSH + Firewall configured  
- 🧩 **Modular Design**: Each distro has its own script  
- 🖥 **Development Environments**: Android Studio, VSCode  
- 🐳 **Docker + Portainer + Cockpit** installed automatically  
- 🌈 **Enhanced Login Interface**: Shows IP, CPU, Memory, Distro with htop-style colors
---

## Quick Start

```bash
# 1. Switch to root user
su -

# 2. Run initialization script (using wget, works on minimal systems)
bash <(wget -qO- https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init.sh)

# 3. Or using curl (preferred if available)
bash <(curl -fsSL https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init.sh)
````
```bash
# Android Studio
bash <(wget -qO- https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init/dev/android-studio-debian.sh)

# VSCode
bash <(wget -qO- https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init/dev/vscode-debian.sh)

# Docker + Portainer
bash <(wget -qO- https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init/dev/docker-debian.sh)

# TTY-Enhance
bash <(wget -qO- https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init/enhance-login.sh)
```
---

## Notes for sudo/wheel group

* Debian/Ubuntu 用户：加入 sudo 组
* CentOS/Rocky 用户：加入 wheel 组

示例：

```bash
usermod -aG sudo myuser       # Debian/Ubuntu
usermod -aG wheel myuser      # CentOS/Rocky
```

---

## Repository Structure

```
init/
├─ dev/
│  ├─ android-studio-debian.sh
│  ├─ vscode-debian.sh
│  └─ docker-debian.sh
├─ debian-init.sh
├─ centos-init.sh
├─ enhance-login.sh
init.sh
LICENSE
README.md
```

---

## License

This project is licensed under the [MIT License](LICENSE).
