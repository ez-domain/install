<div align="center">

<img src="https://raw.githubusercontent.com/ez-domain/images/main/logo/ezdomain.png" width="300" alt="ezdomain logo"/>

**Map friendly local domain names to your services with automatic HTTPS**

`project.test → localhost:3000` in seconds, trusted certificate included

[![macOS](https://img.shields.io/badge/macOS-arm64%20%7C%20amd64-black?logo=apple)](https://github.com/ez-domain/install/releases/latest)
[![Linux](https://img.shields.io/badge/Linux-arm64%20%7C%20amd64-orange?logo=linux&logoColor=white)](https://github.com/ez-domain/install/releases/latest)
[![Windows](https://img.shields.io/badge/Windows-x64-blue?logo=windows)](https://github.com/ez-domain/install/releases/latest)
[![Latest Release](https://img.shields.io/github/v/release/ez-domain/install?label=latest&color=brightgreen)](https://github.com/ez-domain/install/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/ez-domain/install/total?label=downloads)](https://github.com/ez-domain/install/releases)

</div>

---

## Install

### macOS & Linux

```sh
curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/install.sh | sh
```

> On macOS and Linux non-root: requires `sudo`. You will be prompted for your password to install the binary and trust the local CA. On Proxmox (running as root) no password is needed.

**Specific version:**

```sh
curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/install.sh | sh -s -- --version v0.1.0
```

### Windows

Download **[ezdomain-setup.exe](https://github.com/ez-domain/install/releases/latest)** and run the installer wizard.

### Proxmox

See the [Proxmox](#proxmox-1) section below for installing on a Proxmox node to cover all VMs and containers at once.

---

## What it does

1. Detects your OS and architecture
2. Downloads the binary from the latest release
3. Generates a local CA and installs it into the system trust store
4. Registers and starts ezdomain as a background service
5. Adds `ezdomain.dev` to your hosts file

Once done, open **[https://ezdomain.dev](https://ezdomain.dev)** to manage your domain aliases.

---

## Supported Platforms

| OS | Architecture |
|----|---|
| macOS | arm64 (Apple Silicon) |
| macOS | amd64 (Intel) |
| Linux | amd64 |
| Linux | arm64 |
| Windows | x64 |

---

## Ports

ezdomain binds the following ports on your machine:

| Port | Protocol | Purpose |
|------|----------|---------|
| 90 | TCP | HTTP → HTTPS redirect (configurable) |
| 443 | TCP | HTTPS reverse proxy |
| 53 | UDP/TCP | DNS (LAN, for other devices on your network) |
| 5300 | UDP/TCP | DNS (local fallback) |

> Make sure nothing else is already listening on ports 90 or 443 before installing. The HTTP port (default `90`) can be changed in **Settings** to free it up for another program.

---

## Proxmox

Installing ezdomain on a Proxmox node is the most efficient way to cover all VMs and LXC containers at once. The node's bridge IP (`vmbr0`) is already reachable by every guest, so you only need to configure DNS in one place.

### 1. Check port 53

Port 53 must be free before ezdomain can listen on it. On most Proxmox installs, it already exists.

```sh
ss -tulnp | grep :53
```

If nothing is listed, skip to step 2. If something is holding port 53, stop it:

| Process | Fix |
|---|---|
| `systemd-resolved` | `mkdir -p /etc/systemd/resolved.conf.d && echo -e "[Resolve]\nDNSStubListener=no" > /etc/systemd/resolved.conf.d/no-stub.conf && systemctl restart systemd-resolved` |
| `dnsmasq` | `systemctl disable --now dnsmasq` |
| `bind9` / `named` | `systemctl disable --now bind9` |

### 2. Install ezdomain

```sh
curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/install.sh | sh
```

### 3. Apply DNS to all guests

Open the ezdomain dashboard and go to **Setup**. When running on a Proxmox node, a Proxmox section appears automatically showing all detected VMs and LXC containers.

Click **Apply DNS + CA to all guests** and ezdomain will configure each guest's nameserver and install the CA certificate (LXC only) without any manual commands. A live log shows the result for each guest.

> **VMs** receive the DNS setting via cloud-init config and pick it up on next reboot. **LXC containers** apply immediately (container must be running for CA trust).

### New guests

Enable **Auto-apply** in the Setup page. ezdomain watches for new VMs and containers every 30 seconds and configures them automatically. No action needed when you create a new guest.

---

## Commands

```sh
ezdomain completion    # Generate the autocompletion script for the specified shell
ezdomain help          # Help about any command
ezdomain install       # Generate CA, trust it system-wide, and install the service
ezdomain reinstall     # Uninstall, wipe config, and do a fresh install
ezdomain reset         # Clear all domain aliases (service keeps running)
ezdomain restart       # Restart the service
ezdomain serve         # Run in the foreground (Ctrl+C to stop)
ezdomain start         # Start the service
ezdomain status        # Show service status and diagnostics
ezdomain stop          # Stop the service
ezdomain trust         # Install the local CA into the system trust store (re-run if browser shows cert error)
ezdomain update        # Check for a newer version and update the binary
```

> Prefix with `sudo` on macOS or Linux if not running as root.

---

## Uninstall

**macOS / Linux:**

```sh
ezdomain uninstall
```

> Prefix with `sudo` if not running as root.

**Windows:**

Open **Settings → Apps** and uninstall "ezdomain - Local Domain Manager", or run `C:\ezdomain\uninstall.exe`.

Removes the service, untrusts the CA, cleans up hosts entries, and deletes the binary.

---

<div align="center">

Made by [ansori34](https://github.com/ansori34)

</div>
