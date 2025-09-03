# Linux Init Scripts 🚀

A collection of Linux initialization scripts for quickly setting up servers on **Debian**, **Ubuntu**, and more distributions in the future.

## Features
- 🐧 **Multi-Distribution Support**: Debian, Ubuntu (more coming soon)
- ⚡ **One Command Setup**: Install SSH, sudo, UFW automatically
- 🔒 **Basic Security**: OpenSSH + Firewall configuration
- 🧩 **Modular Design**: Each distro has its own script, easy to extend

---

## Prerequisites & Quick Start

On a freshly installed Debian/Ubuntu system, follow these steps:

```bash
# 1. Switch to root user
su -

# 2. Run the initialization script directly with curl
bash <(curl -fsSL https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init.sh)

# Alternatively, using wget
bash <(wget -qO- https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init.sh)
````

The script will:

* Detect your Linux distribution
* Install essential tools: **OpenSSH Server**, **sudo**, **UFW**
* Enable firewall and open SSH port
* Configure services to start on boot

### Notes for sudo

* If no non-root user exists yet, you will need to create one later and add it to the `sudo` group:

```bash
usermod -aG sudo <username>
```

Example:

```bash
usermod -aG sudo myuser
```

* Log out and log back in for the permission to take effect.

---

## Repository Structure

```
linux-init-scripts/
├── README.md                  # Project introduction
├── init.sh                    # Entry script: detects OS, calls common.sh
└── init/
    └── common.sh             # Universal initialization script
```

---

## Planned Features

* [ ] Add more Linux distributions (CentOS, Rocky Linux, etc.)
* [ ] Optional arguments (e.g., `--no-firewall`)
* [ ] Security enhancements (Fail2ban, SSH keys)

---

## License

This project is licensed under the [MIT License](LICENSE).
