# ezdomain

Map friendly domain names to local services with automatic HTTPS, without manual certificate setup or browser warnings.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/install.sh | sh
```

> Requires `sudo`. You will be prompted for your password to install the binary and trust the local CA.

## Install a specific version

```sh
curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/install.sh | sh -s -- --version v0.1.0
```

## What it does

1. Detects your OS and architecture (macOS/Linux, amd64/arm64)
2. Downloads and installs the binary to `/usr/local/bin/ezdomain`
3. Generates a local CA and trusts it system-wide
4. Installs and starts the background service

## Supported platforms

| OS    | Architecture |
|-------|-------------|
| macOS | arm64 (Apple Silicon) |
| macOS | amd64 (Intel) |
| Linux | amd64 |
| Linux | arm64 |

## After install

Open **https://ezdomain.dev** in your browser to manage domain aliases.

```sh
sudo ezdomain status    # check service status
sudo ezdomain stop      # stop the service
sudo ezdomain start     # start the service
```

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/uninstall.sh | sh
```

Removes the service, untrusts the CA, and deletes the binary.
