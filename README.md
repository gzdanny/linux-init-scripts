# Linux Init Scripts 🚀

A collection of Linux initialization scripts for quickly setting up servers on Debian, Ubuntu, CentOS, and Rocky Linux.

## Features
- 🐧 Multi-Distribution Support: Debian/Ubuntu and CentOS/Rocky
- ⚡ One Command Setup: Install SSH, sudo, firewall automatically
- 🔒 Basic Security: SSH + Firewall configured
- 🧩 Modular Design: Each distro has its own script

---

## Quick Start

```bash
# 1. Switch to root user
su -

# 2. Run initialization script
bash <(curl -fsSL https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init.sh)

# Or using wget
bash <(wget -qO- https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init.sh)
````

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
linux-init-scripts/
├── README.md
├── init.sh
└── init/
    ├── debian-init.sh
    └── centos-init.sh
```

---

## License

This project is licensed under the [MIT License](LICENSE).
