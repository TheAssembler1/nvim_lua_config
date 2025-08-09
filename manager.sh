#!/bin/bash
set -xe

update_nvim() {
    echo "Copying Neovim Lua config source..."
    rsync -av --exclude 'manager.sh' . ~/.config/nvim
}

install_nvim() {
    echo "Creating Neovim config directory..."
    mkdir -p ~/.config/nvim

    echo "Copying Neovim Lua config source..."
    rsync -av --exclude 'manager.sh' . ~/.config/nvim

    echo "Moving into Neovim config directory..."
    cd ~/.config/nvim

    echo "Uninstalling previous Neovim installation and dependencies..."
    sudo apt remove neovim -y
    sudo rm -rf /opt/nvim

    echo "Installing necessary apt packages..."
    sudo apt update
    sudo apt install -y xclip xsel lua5.3 liblua5.3-dev luarocks ccls ripgrep fd-find cargo curl python3-pip

    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    echo "Updating rustc..."
    source "$HOME/.cargo/env"
    rustup update stable

    echo "Installing tree-sitter CLI..."
    cargo install tree-sitter-cli

    echo "Downloading and installing Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz

    echo "Installing latest Node.js..."
    curl -sL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs

    echo "Installing neovim npm package globally..."
    sudo npm install -g neovim

    echo "Installing pynvim for Python support..."
    pip3 install --user pynvim

    echo "Adding Neovim to PATH for current session..."
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin/"

    echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin/"' >> ~/.bashrc

    echo "Neovim installation completed!"
    echo "Please restart your terminal or run 'source ~/.bashrc' to update your PATH permanently."
}

uninstall_nvim() {
    echo "Removing Neovim configuration..."
    rm -rf ~/.config/nvim

    echo "Removing Neovim binary and dependencies..."
    sudo apt remove -y xclip xsel lua5.3 liblua5.3-dev luarocks ccls ripgrep fd-find cargo nodejs neovim
    sudo rm -rf /opt/nvim

    echo "Removing system-installed Rust..."
    sudo apt remove -y rustc cargo
    sudo rm -f /usr/bin/rustc /usr/bin/cargo
    sudo rm -rf /usr/lib/rustlib

    echo "Uninstalling rustup and removing rustup directories..."
    rustup self uninstall -y
    rm -rf ~/.cargo ~/.rustup

    echo "Ensuring that system-wide Rust is completely removed..."
    which rustc && sudo rm -f $(which rustc)
    which cargo && sudo rm -f $(which cargo)

    echo "Removing Node.js..."
    sudo apt purge -y nodejs

    echo "Removing neovim npm package globally..."
    sudo npm uninstall -g neovim

    echo "Removing pynvim Python package for current user..."
    pip3 uninstall -y pynvim || true

    echo "Removing Neovim from PATH..."
    sed -i '/\/opt\/nvim-linux-x86_64\/bin/d' ~/.bashrc
    # Do NOT source ~/.bashrc here — ask user to restart terminal

    echo "Uninstallation completed!"
}

# Check for user input
if [ "$1" == "install" ]; then
    install_nvim
elif [ "$1" == "uninstall" ]; then
    uninstall_nvim
elif [ "$1" == "update" ]; then 
    update_nvim
else
    echo "Usage: $0 {install|uninstall|update}"
    exit 1
fi

