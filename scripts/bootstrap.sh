#!/usr/bin/env bash
set -euo pipefail

# Detect distro using /etc/os-release
detect_os() {
  if [ -r /etc/os-release ]; then
    . /etc/os-release
    echo "${ID:-}"
  else
    echo ""
  fi
}

install_deps_debian() {
  sudo apt update
  sudo apt install -y \
    git stow curl unzip tar \
    neovim ripgrep fzf fd-find \
    build-essential cmake pkg-config make \
    python3-venv python3-pip \
    nodejs npm \
    lazygit || true

  # Provide 'fd' alias if only fdfind exists
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  fi
}

install_deps_arch() {
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm \
    git stow curl unzip tar \
    neovim ripgrep fzf fd \
    base-devel cmake pkgconf make \
    python-pip python-virtualenv \
    nodejs npm \
    lazygit
}

install_deps_fedora() {
  sudo dnf install -y \
    git stow curl unzip tar \
    neovim ripgrep fzf fd-find \
    @development-tools cmake pkgconf-pkg-config make \
    python3-venv python3-pip \
    nodejs npm \
    lazygit || true

  # fd is 'fdfind' on some RPM distros; provide alias
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  fi
}

install_deps_suse() {
  sudo zypper refresh
  sudo zypper install -y \
    git stow curl unzip tar \
    neovim ripgrep fzf fd \
    gcc gcc-c++ make cmake pkgconf \
    python3-pip python3-virtualenv \
    nodejs npm \
    lazygit || true
}

stow_packages() {
  # Stow any packages that exist
  for pkg in nvim lazygit; do
    if [ -d "$pkg" ]; then
      echo "Stowing $pkg"
      stow -vt "$HOME" "$pkg"
    fi
  done
}

post_nvim() {
  # Headless sync (safe if NVIM >= 0.9)
  if command -v nvim >/dev/null 2>&1; then
    echo "Running headless Neovim sync (plugins + Treesitter)…"
    nvim --headless "+Lazy! sync" "+TSUpdate" "+qall" || true
  fi
}

main() {
  local os_id
  os_id="$(detect_os)"

  case "$os_id" in
    debian|ubuntu|linuxmint|pop)
      install_deps_debian ;;
    arch|manjaro|endeavouros)
      install_deps_arch ;;
    fedora)
      install_deps_fedora ;;
    opensuse*|sles)
      install_deps_suse ;;
    *)
      echo "Unknown or unsupported distro: '$os_id'. Install deps manually, then continue."
      ;;
  esac

  stow_packages
  post_nvim

  echo "Done. Open Neovim and let Lazy finish if needed: nvim"
  echo "Troubleshooting: if telescope-fzf-native fails to build, check build tools + cmake."
}

main "$@"

