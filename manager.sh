#!/bin/bash

install_nvim() {
    echo "Creating Neovim config directory..."
    mkdir -p ~/.config/nvim

    echo "Copying Neovim Lua config source..."
    cp -r * ~/.config/nvim

    echo "Moving into Neovim config directory..."
    cd ~/.config/nvim || exit

    # Uninstall previous dependencies
    echo "Uninstalling previous Neovim installation and dependencies..."
    sudo apt remove neovim -y
    sudo rm -rf /opt/nvim

    # Install required apt packages
    echo "Installing necessary apt packages..."
    sudo apt update
    sudo apt install ccls ripgrep fd-find cargo -y

    # Install rustup
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Update rustc
    echo "Updating rustc..."
    source "$HOME/.cargo/env"
    rustup update stable

    # Install tree-sitter CLI
    echo "Installing tree-sitter CLI..."
    cargo install tree-sitter-cli

    # Install Neovim
    echo "Downloading and installing Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz

    # Install latest Node.js
    echo "Installing latest Node.js..."
    curl -sL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install nodejs -y

    # Add Neovim to PATH
    echo "Adding Neovim to PATH..."
    echo 'export PATH="$PATH:/opt/nvim-linux64/bin/"' >> ~/.bashrc
    source ~/.bashrc

    echo "Neovim installation completed!"
}

uninstall_nvim() {
    echo "Removing Neovim configuration..."
    rm -rf ~/.config/nvim

    echo "Removing Neovim binary and dependencies..."
    sudo apt remove ccls ripgrep fd-find cargo nodejs neovim -y
    sudo rm -rf /opt/nvim

    # Remove system-installed Rust binaries from /usr/bin
    echo "Removing system-installed Rust..."
    sudo apt remove rustc cargo -y
    sudo rm -f /usr/bin/rustc /usr/bin/cargo
    sudo rm -rf /usr/lib/rustlib

    # Uninstall rustup and remove its directories
    echo "Uninstalling rustup and removing rustup directories..."
    rustup self uninstall -y
    rm -rf ~/.cargo ~/.rustup

    # Make sure no remnants of system-installed Rust exist
    echo "Ensuring that system-wide Rust is completely removed..."
    which rustc && sudo rm -f $(which rustc)
    which cargo && sudo rm -f $(which cargo)

    # Remove Node.js
    echo "Removing Node.js..."
    sudo apt purge nodejs -y

    # Remove Neovim from PATH
    echo "Removing Neovim from PATH..."
    sed -i '/\/opt\/nvim-linux64\/bin/d' ~/.bashrc
    source ~/.bashrc

    echo "Uninstallation completed!"
}

# Check for user input
if [ "$1" == "install" ]; then
    install_nvim
elif [ "$1" == "uninstall" ]; then
    uninstall_nvim
else
    echo "Usage: $0 {install|uninstall}"
    exit 1
fi

