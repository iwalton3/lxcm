# lxcm

Simplified container management system with shared compressed templates, backups, firewall management, and secure defaults.

## Installation

The install feature is built into the script and will install all needed dependencies on Debian systems.

```bash
./lxcm install
```

To use lxcm on Ubuntu, these steps are also needed:

```bash
chmod 755 /var/lib/lxc
echo ". /etc/bash_completion" >> ~/.bashrc
```

## Basic Usage

To create a new container using the wizard:

```bash
lxcm ez
```

To get a list of all available commands:

```bash
lxcm
```

