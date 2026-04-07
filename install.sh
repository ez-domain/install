#!/bin/sh
set -e

REPO="ansori34/ezdomain"
BIN="ezdomain"
INSTALL_DIR="/usr/local/bin"

# Defaults
TAG=""
AUTO_START=0

usage() {
  echo "Usage: install.sh [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --version <tag>   Install a specific version (e.g. v0.1.0). Defaults to latest."
  echo "  --auto-start      Start the ezdomain service immediately after install."
  echo "  --help, -h        Show this help message."
  echo ""
  echo "Examples:"
  echo "  # Install latest version"
  echo "  curl -fsSL https://raw.githubusercontent.com/$REPO/main/install.sh | sh"
  echo ""
  echo "  # Install specific version"
  echo "  curl -fsSL https://raw.githubusercontent.com/$REPO/main/install.sh | sh -s -- --version v0.1.0"
  echo ""
  echo "  # Install latest and start service immediately"
  echo "  curl -fsSL https://raw.githubusercontent.com/$REPO/main/install.sh | sh -s -- --auto-start"
}

# Parse arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --version)
      TAG="$2"
      shift 2
      ;;
    --auto-start)
      AUTO_START=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

# Detect OS
OS=$(uname -s)
case "$OS" in
  Darwin) OS="darwin" ;;
  Linux)  OS="linux"  ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)        ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Resolve release tag
if [ -z "$TAG" ]; then
  echo "Fetching latest release..."
  TAG=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep '"tag_name"' | head -1 | cut -d'"' -f4)

  if [ -z "$TAG" ]; then
    TAG=$(curl -fsSL "https://api.github.com/repos/$REPO/releases" \
      | grep '"tag_name"' | head -1 | cut -d'"' -f4)
  fi

  if [ -z "$TAG" ]; then
    echo "Could not determine latest release."
    echo "Specify a version explicitly:"
    echo "  ... | sh -s -- --version v0.1.0"
    exit 1
  fi
fi

FILENAME="${BIN}_${OS}_${ARCH}"
URL="https://github.com/$REPO/releases/download/$TAG/$FILENAME"

echo "Downloading $BIN $TAG ($OS/$ARCH)..."
if ! curl -fsSL "$URL" -o "/tmp/$BIN"; then
  echo ""
  echo "Download failed. Verify the release exists at:"
  echo "  https://github.com/$REPO/releases/tag/$TAG"
  exit 1
fi
chmod +x "/tmp/$BIN"

echo "Installing to $INSTALL_DIR/$BIN (requires sudo)..."
sudo mv "/tmp/$BIN" "$INSTALL_DIR/$BIN"

echo ""
echo "Setting up ezdomain (you may be asked for your password to trust the local CA)..."
sudo "$INSTALL_DIR/$BIN" install

if [ "$AUTO_START" = "1" ]; then
  echo ""
  echo "Starting ezdomain service..."
  sudo "$INSTALL_DIR/$BIN" start
fi

echo ""
echo "ezdomain $TAG installed successfully."
echo ""
echo "To start the service:"
echo "  sudo ezdomain start"
echo ""
echo "To stop the service:"
echo "  sudo ezdomain stop"
