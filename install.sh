echo "creating nvim config dir"
mkdir ~/.config/nvim
echo "copying nvim lua config src"
cp -r * ~/.config/nvim
echo "moving into nvim config dir"
cd ~/.config/nvim

# uninstalling previous dependencies
sudo apt remove neovim -y
sudo rm -rf /opt/nvim

# installing apt packages
sudo apt install ccls ripgrep fd-find cargo nodejs tmux -y

# updating rustc
rustup update stable

# installing tree-sitter
cargo install tree-sitter-cli

# install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# adding nvim to path
echo "export PATH="$PATH:/opt/nvim-linux64/bin/"" >> ~/.bashrc
echo 'if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then 
  tmux a -t default || exec tmux new -s default && exit; 
fi' >> ~/.bashrc
source ~/.bashrc

