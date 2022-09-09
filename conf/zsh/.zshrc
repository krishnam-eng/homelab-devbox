#!/usr/bin/env zsh
################
# description : This script (known as _startup file_) will be executed by zsh and all zsh preferences goes here
# zsh_version : 5.8 (zsh --version)
# author	    : krishnam
################

[[ -f $HOME/hrt/etc/ctrflags/enablepowertheme ]] && source $HOME/hrt/boot/conf/zsh/extensions/p10k-instant-prompt.zsh

source $HOME/hrt/boot/custom/env/interactice-shell/prompt.bash

source $HOME/hrt/boot/conf/zsh/elements/pre-launch-cmds.zshrc

source $HOME/hrt/boot/conf/zsh/elements/expansions-globbing.zshrc

source $HOME/hrt/boot/conf/zsh/elements/load-aliases-functions.zshrc

source $HOME/hrt/boot/conf/zsh/elements/history-configuration.zshrc

source $HOME/hrt/boot/conf/zsh/elements/auto-completion.zshrc

source $HOME/hrt/boot/conf/zsh/elements/set-opts-zle.zshrc

source $HOME/hrt/boot/conf/zsh/elements/prompt.zshrc

source $HOME/hrt/boot/conf/zsh/extensions/fish_shell.zsh

[[ -f $HOME/hrt/etc/ctrflags/enablepowertheme ]] && source $HOME/hrt/boot/conf/zsh/extensions/.p10k.zsh && source $HOME/hrt/boot/conf/zsh/themes/powerlevel10k.zsh-theme
