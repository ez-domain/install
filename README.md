<div align="center">

<img src="https://raw.githubusercontent.com/ez-domain/images/main/logo/ezdomain.png" width="300" alt="ezdomain logo"/>

**Map friendly local domain names to your services with automatic HTTPS**

`project.test → localhost:3000` in seconds, trusted certificate included

[![macOS](https://img.shields.io/badge/macOS-arm64%20%7C%20amd64-black?logo=apple)](https://github.com/ez-domain/install/releases/latest)
[![Linux](https://img.shields.io/badge/Linux-arm64%20%7C%20amd64-orange?logo=linux&logoColor=white)](https://github.com/ez-domain/install/releases/latest)
[![Windows](https://img.shields.io/badge/Windows-x64-blue?logo=windows)](https://github.com/ez-domain/install/releases/latest)
[![Latest Release](https://img.shields.io/github/v/release/ez-domain/install?label=latest&color=brightgreen)](https://github.com/ez-domain/install/releases/latest)

</div>

---

## Install

### macOS & Linux

```sh
curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/install.sh | sh
```

> Requires `sudo`. You will be prompted for your password to install the binary and trust the local CA.

**Specific version:**

```sh
curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/install.sh | sh -s -- --version v0.1.0
```

### Windows

Download **[ezdomain-setup.exe](https://github.com/ez-domain/install/releases/latest)** and run the installer wizard.

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
| 80 | TCP | HTTP → HTTPS redirect |
| 443 | TCP | HTTPS reverse proxy |
| 53 | UDP/TCP | DNS (LAN — for other devices on your network) |
| 5300 | UDP/TCP | DNS (local fallback) |

> Make sure nothing else (nginx, Apache, another dev server) is already listening on ports 80 or 443 before installing.

---

## After Install

```sh
sudo ezdomain completion    # Generate the autocompletion script for the specified shell
sudo ezdomain help          # Help about any command
sudo ezdomain install       # Generate CA, trust it system-wide, and install the service
sudo ezdomain reinstall     # Uninstall, wipe config, and do a fresh install
sudo ezdomain reset         # Clear all domain aliases (service keeps running)
sudo ezdomain serve         # Run in the foreground (Ctrl+C to stop)
sudo ezdomain start         # Start the service
sudo ezdomain status        # Show service status and diagnostics
sudo ezdomain stop          # Stop the service
sudo ezdomain trust         # Install the local CA into the system trust store (re-run if browser shows cert error)
```

---

## Uninstall

**macOS / Linux:**

```sh
sudo ezdomain uninstall
```

**Windows:**

Open **Settings → Apps** and uninstall "ezdomain - Local Domain Manager", or run `C:\ezdomain\uninstall.exe`.

Removes the service, untrusts the CA, cleans up hosts entries, and deletes the binary.

---

<div align="center">

Made by [ansori34](https://github.com/ansori34)

</div>
