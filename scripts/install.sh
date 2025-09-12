#!/bin/bash

set -eo pipefail

# ==================================================================
# 全局环境变量设置
# ==================================================================

# 识别是否处于root用户下，决定是否使用sudo前缀
if [[ $EUID -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
fi

ARCH="$(uname -m)"

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS"
    exit 1
fi

# 目前只支持这三种操作系统
case $OS in
    centos)
        ;;
    ubuntu)
        ;;
    openEuler)
        ;;
    *) echo "Unsupported Operating System: $OS" >&2; exit 1 ;;
esac

# ==================================================================
# 文件路径全局变量设置
# ==================================================================

PROJECT_DIR="$(dirname "$(dirname "$(realpath "$0")")")"

# ==================================================================
# 根据ARCH选择nvim stable version下载地址
# ==================================================================

URL=""
DIR=""

case "$ARCH" in
    aarch64|arm64)
        URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-arm64.tar.gz"
        DIR="nvim-linux-arm64"
        ;;
    x86_64)
        URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
        DIR="nvim-linux-x86_64"
        ;;
    *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

# curl下载nvim
echo ">>> Downloading Neovim nightly for $ARCH ..."
curl -LO "$URL"

echo ">>> Extracting ..."
tar -zxvf "$DIR.tar.gz"

# 安装nvim
echo ">>> Installing to /opt/nvim ..."
$SUDO mkdir -p /opt/nvim
$SUDO rsync -a "$DIR"/ /opt/nvim/
$SUDO ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

echo "Done!"
nvim --version

# ==================================================================
# 删除旧版本nvim配置
# ==================================================================

mkdir -p ~/.config
[[ -d ~/.config/nvim ]] && rm -rf ~/.config/nvim
[[ -d ~/.local/share/nvim ]] && rm -rf ~/.local/share/nvim

# ==================================================================
# 将新版本nvim配置复制到config下
# ==================================================================

cp -r "$PROJECT_DIR" ~/.config/nvim

echo "nvim config copied to ~/.config/nvim"

# ==================================================================
# 安装nvm版本管理软件并安装latest版本的node和npm
# ==================================================================

if ! command -v nvm >/dev/null 2>&1; then
  echo ">>> npm not found ..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash -s -- --no-use
  
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

echo ">>> Installing the latest Node.js LTS ..."
nvm install --lts
nvm use --lts

echo ">>> Installation complete – versions:"
node --version
npm  --version

# ==================================================================
# 安装telescope要求的依赖项ripgrep和fd-find
# ==================================================================

echo ">>> Installing ripgrep and fd-find ..."

case $OS in
    centos)
        ;;
    ubuntu)
        $SUDO apt-get update
        $SUDO apt-get install -y ripgrep fd-find
        ;;
    openEuler)
        pip install ripgrep
        pip install fd
	;;
    *) echo "Unsupported Operating System: $OS" >&2; exit 1 ;;
esac

# ==================================================================
# 删除项目文件夹下的下载文件
# =================================================================

rm -f "$PROJECT_DIR/nvim-linux-x86_64.tar.gz"
rm -rf "$PROJECT_DIR/nvim-linux-x86_64"




