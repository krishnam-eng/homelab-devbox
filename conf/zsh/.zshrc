#!/usr/bin/env zsh

# initialize
[[ -f $HOME/hrt/etc/ctrflags/enablepowertheme ]] && source $HOME/hrt/boot/conf/zsh/extensions/p10k-instant-prompt.zsh

if [ "$(uname)" = "Linux" -o "$(uname)" = "Darwin" ]; then
  for efile in $HOME/hrt/boot/conf/zsh/rc.d/*.zshrc
  do
   source $efile
  done
  unset efile
fi

# Extend zsh behavior with fish shell capabilities
source $HOME/hrt/boot/conf/zsh/extensions/fish_shell.zsh

# optional powerlevel10k theme
[[ -f $HOME/hrt/etc/ctrflags/enablepowertheme ]] && source $HOME/hrt/boot/conf/zsh/extensions/.p10k.zsh && source $HOME/hrt/ext/powerlevel10k/powerlevel10k.zsh-theme

# Simple Approach
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
# echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc