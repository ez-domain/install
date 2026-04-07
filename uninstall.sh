#!/bin/sh
set -e

BIN="ezdomain"
INSTALL_DIR="/usr/local/bin"

if ! command -v "$BIN" > /dev/null 2>&1; then
  echo "ezdomain is not installed."
  exit 0
fi

echo "Removing ezdomain..."
sudo "$INSTALL_DIR/$BIN" uninstall

echo "Removing binary..."
sudo rm -f "$INSTALL_DIR/$BIN"

echo ""
echo "ezdomain has been removed."
