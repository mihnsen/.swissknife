#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# i3 config
if hash i3 2>/dev/null; then
  echo -e "\n\033[32mConfiguring i3\033[m";
  mkdir $HOME/.config/i3;
  ln -sf $DIR/i3/config $HOME/.config/i3/;
fi

# vim config
echo -e "\n\033[32mConfiguring vim\033[m";
ln -sf $DIR/.vimrc $HOME/;
if [ ! -d "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
vim +PluginInstall +qall

# neovim config linking
# require neovim to be preinstalled
if hash nvim 2>/dev/null; then
  echo -e "\n\033[32mLinking neovim\033[m";
  mkdir -p ~/.config/nvim
  ln -s $HOME/.vimrc ~/.config/nvim/init.vim
  ln -s $HOME/.vim ~/.config/nvim/
fi

# terminal patched font
echo -e "\n\033[32mInstalling powerline patched fonts\033[m";
git clone https://github.com/powerline/fonts.git $HOME/powerline-fonts;
$HOME/powerline-fonts/install.sh;
rm -rf $HOME/powerline-fonts;

# git config
if hash git 2>/dev/null; then
  echo -e "\n\033[32mConfiguring git\033[m";
  ln -sf $DIR/.gitconfig $HOME/;
fi

# bash config
echo -e "\n\033[32mConfiguring bash\033[m";
touch $HOME/.bashrc
if grep -Fxq ".bash_kit" $HOME/.bashrc; then
  echo ".bash_kit already included"
else
  ln -sf $DIR/.bash_kit $HOME/;
  echo source \$HOME/.bash_kit >> $HOME/.bashrc
fi
touch ~/.hushlogin
