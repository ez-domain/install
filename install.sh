#!/bin/sh
set -e

REPO="ez-domain/install"
BIN="ezdomain"
INSTALL_DIR="/usr/local/bin"

# Defaults
TAG=""

# Colors (with fallback for terminals that don't support colors or 256-color)
if [ -t 1 ] && [ "${TERM}" != "dumb" ]; then
  BOLD='\033[1m'
  DIM='\033[2m'
  GREEN='\033[0;32m'
  CYAN='\033[0;36m'
  YELLOW='\033[0;33m'
  RED='\033[0;31m'
  RESET='\033[0m'
  if [ "${TERM##*-}" = "256color" ] || [ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]; then
    ORANGE='\033[38;5;208m'
  else
    ORANGE='\033[0;33m'  # fallback to yellow on basic terminals
  fi
else
  BOLD='' DIM='' GREEN='' CYAN='' ORANGE='' YELLOW='' RED='' RESET=''
fi

info()    { printf "  ${CYAN}>${RESET} %s\n" "$1"; }
success() { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
warn()    { printf "  ${YELLOW}!${RESET} %s\n" "$1"; }
error()   { printf "  ${RED}✗${RESET} %s\n" "$1" >&2; }
step()    { printf "\n${BOLD}%s${RESET}\n" "$1"; }

banner() {
  printf "\n"
  printf "${BOLD}${ORANGE}  ███████╗███████╗██████╗  ██████╗ ███╗   ███╗ █████╗ ██╗███╗   ██╗${RESET}\n"
  printf "${BOLD}${ORANGE}  ██╔════╝╚══███╔╝██╔══██╗██╔═══██╗████╗ ████║██╔══██╗██║████╗  ██║${RESET}\n"
  printf "${BOLD}${ORANGE}  █████╗    ███╔╝ ██║  ██║██║   ██║██╔████╔██║███████║██║██╔██╗ ██║${RESET}\n"
  printf "${BOLD}${ORANGE}  ██╔══╝   ███╔╝  ██║  ██║██║   ██║██║╚██╔╝██║██╔══██║██║██║╚██╗██║${RESET}\n"
  printf "${BOLD}${ORANGE}  ███████╗███████╗██████╔╝╚██████╔╝██║ ╚═╝ ██║██║  ██║██║██║ ╚████║${RESET}\n"
  printf "${BOLD}${ORANGE}  ╚══════╝╚══════╝╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝${RESET}\n"
  printf "\n"
  printf "  ${DIM}Map localhost ports to clean local domains with HTTPS${RESET}\n"
  printf "\n"
}

usage() {
  banner
  printf "${BOLD}Usage:${RESET}\n"
  printf "  install.sh [OPTIONS]\n\n"
  printf "${BOLD}Options:${RESET}\n"
  printf "  ${CYAN}--version${RESET} <tag>   Install a specific version (e.g. v0.1.0). Defaults to latest.\n"
  printf "  ${CYAN}--help, -h${RESET}        Show this help message.\n\n"
  printf "${BOLD}Examples:${RESET}\n"
  printf "  ${DIM}# Install latest version${RESET}\n"
  printf "  curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/install.sh | sh\n\n"
  printf "  ${DIM}# Install specific version${RESET}\n"
  printf "  curl -fsSL https://raw.githubusercontent.com/ez-domain/install/main/install.sh | sh -s -- --version v0.1.0\n"
  printf "\n"
}

# Parse arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --version)
      TAG="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

banner

# Detect OS
step "Detecting system..."
OS=$(uname -s)
case "$OS" in
  Darwin) OS="darwin" ;;
  Linux)  OS="linux"  ;;
  *)
    error "Unsupported OS: $OS"
    exit 1
    ;;
esac

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)        ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)
    error "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

success "Detected ${OS}/${ARCH}"

# Resolve release tag
if [ -z "$TAG" ]; then
  info "Fetching latest release..."
  TAG=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep '"tag_name"' | head -1 | cut -d'"' -f4)

  if [ -z "$TAG" ]; then
    TAG=$(curl -fsSL "https://api.github.com/repos/$REPO/releases" \
      | grep '"tag_name"' | head -1 | cut -d'"' -f4)
  fi

  if [ -z "$TAG" ]; then
    error "Could not determine latest release."
    warn "Specify a version explicitly:"
    printf "    ... | sh -s -- --version v0.1.0\n"
    exit 1
  fi
fi

printf "  ${GREEN}✓${RESET} Found version ${BOLD}${TAG}${RESET}\n"

FILENAME="${BIN}_${OS}_${ARCH}"
URL="https://github.com/$REPO/releases/download/$TAG/$FILENAME"

step "Downloading..."
info "$BIN $TAG ($OS/$ARCH)"
if ! curl -fsSL "$URL" -o "/tmp/$BIN"; then
  printf "\n"
  error "Download failed. Verify the release exists at:"
  printf "    https://github.com/$REPO/releases/tag/$TAG\n"
  exit 1
fi
chmod +x "/tmp/$BIN"
success "Download complete"

step "Installing..."
info "Moving to $INSTALL_DIR/$BIN (requires sudo)"
sudo mv "/tmp/$BIN" "$INSTALL_DIR/$BIN"
success "Binary installed"

step "Setting up..."
warn "You may be asked for your password to trust the local CA"
printf "\n  ${ORANGE}▶ ezdomain${RESET}\n"
sudo "$INSTALL_DIR/$BIN" install