# Linux Init Scripts 🚀

A collection of Linux initialization scripts for quickly setting up servers on **Debian**, **Ubuntu**, and more distributions in the future.

## Features
- 🐧 **Multi-Distribution Support**: Debian, Ubuntu (more coming soon)
- ⚡ **One Command Setup**: Install SSH, sudo, UFW automatically
- 🔒 **Basic Security**: OpenSSH + Firewall configuration
- 🧩 **Modular Design**: Each distro has its own script, easy to extend

---

## Quick Start

### Run with `curl`
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init.sh)
````

### Run with `wget`

```bash
bash <(wget -qO- https://raw.githubusercontent.com/gzdanny/linux-init-scripts/main/init.sh)
```

The script will:

1. Detect your Linux distribution
2. Install essential tools (SSH, sudo, UFW)
3. Enable firewall and open SSH port
4. Configure services to start on boot

---

## Repository Structure

```
linux-init-scripts/
│
├── README.md                 # Project introduction
├── init.sh                   # Entry script: detects OS, calls distro script
├── init/
│   ├── debian-init.sh         # Debian initialization
│   ├── ubuntu-init.sh         # Ubuntu initialization (coming soon)
│   └── common.sh              # Shared functions
└── utils/
    ├── detect_os.sh           # OS detection logic
    └── helper.sh              # Helper utilities
```

---

## Planned Features

* [ ] Add Ubuntu support
* [ ] Add CentOS/Rocky Linux support
* [ ] Optional arguments (e.g., `--no-firewall`)
* [ ] Security enhancements (Fail2ban, SSH keys)

---

## License

This project is licensed under the [MIT License](LICENSE).
