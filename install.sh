#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# i3 config
if hash i3 2>/dev/null; then
  echo -e "\n\033[32mConfiguring i3\033[m";
  mkdir $HOME/.config/i3;
  ln -sf $DIR/i3/config $HOME/.config/i3/;
fi

# yabai config
if [[ "$OSTYPE" == "darwin"* ]]; then
  if hash yabai 2>/dev/null; then
    echo -e "\n\033[32mConfiguring yabai\033[m";
    touch $HOME/.yabairc
    ln -sf $DIR/.yabairc $HOME/;
  fi
  if hash yabai 2>/dev/null; then
    echo -e "\n\033[32mConfiguring skhd\033[m";
    touch $HOME/.skhdrc
    ln -sf $DIR/.skhdrc $HOME/;
  fi
  if hash spacebar 2>/dev/null; then
    echo -e "\n\033[32mConfiguring spacebar\033[m";
    touch $HOME/.spacebarrc
    ln -sf $DIR/.spacebarrc $HOME/;
  fi
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

echo -e "\n\033[32mConfiguring private bash\033[m";
if [[ -f $HOME/.bash_private ]]; then
  if grep -Fxq ".bash_private" $HOME/.bashrc; then
    echo ".bash_private already included"
  else
    ln -sf $DIR/.bash_kit $HOME/;
    echo source \$HOME/.bash_private >> $HOME/.bashrc
  fi
else
  echo ".bash_private is not exist, please configure one"
fi

touch ~/.hushlogin

echo -e "\n\033[32mFinnish installation, happy with new env..\033[m";
