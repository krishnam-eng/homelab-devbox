#!/usr/bin/env bash

log_prefix="\033[36;3m[$(date +%FT%T)]\033[0m"

session="unr-bash_$(date +%Y%m)" # refersh session monthly once at max todo: send arg for name prefix
echo "${log_prefix} Session Name: ${session}"

repo_path="~/github/ohmy-linux"  # todo: send arg for repo
echo "${log_prefix} Repo Path: ${repo_path}"

#if (($1='n'))
#then
# tmux kill-server 2>/dev/null;
#fi

tmux has-session -t $session 2>/dev/null
if [ $? != 0 ]
then
    ### New session with first window
	tmux new-session -s $session -n dev -d

	# edit pane
	tmux send-keys -t $session:1.1 "cd $repo_path/bash/upnrung" C-m
	tmux send-keys -t $session:1.1 "clear" C-m
	tmux send-keys -t $session:1.1 "nano $repo_path/bash"

	# execute pane and open with current dir of prev pane
	tmux split-window -v -p 35 -t $session:1  -c "#{pane_current_path}"
	tmux send-keys -t $session:1.2 "cd $repo_path" C-m
	tmux send-keys -t $session:1.2 "git status" C-m

	# commit pane
	tmux split-window -h  -t $session -c "#{pane_current_path}"
	tmux send-keys -t $session:1.3 "cd $repo_path/bash" C-m
	tmux send-keys -t $session:1.3 "ls -r *.sh" C-m

 	# Window "Tmux Config" - update as needed
   	tmux new-window -n tconf -t $session
	tmux send-keys -t $session:2.1 "nano $repo_path/tmux/sessions/bash_practice_session.sh" C-m
	tmux split-window -h -t $session:2
	tmux send-keys -t $session:2.2 "nano $repo_path/tmux/.tmux.conf" C-m

	tmux select-pane -t $session:2.1

	 ### New Window "Shell Configuration" - to update shell / create alias as we learn
	tmux new-window -n sconf -t $session
	tmux send-keys -t $session:3.1 "nano $repo_path/zsh/.zshrc"	C-m

	tmux split-window -h -t $session:3
	tmux send-keys -t $session:3.2 "nano $repo_path/alias/.alias" C-m

	tmux split-window -v -p 50 -t $session:3

	tmux select-pane -t $session:3.1

    # Window "Build Functions" - To have help manual handy
    tmux new-window -n fun -t $session
    tmux send-keys -t $session:4.1 "nano $repo_path/bash/functions.sh" C-m

    tmux split-window -v -p 40 -t $session:4
    tmux send-keys -t $session:4.2 "cd $repo_path/bash/" C-m

    tmux select-pane -t $session:4.1

    # Window "File Browser" - File Navigation
    tmux new-window -n file -t  $session
    tmux send-keys -t $session:5.1 "ranger 2>/dev/null" C-m

	# Window "console"
    tmux select-window -t $session:1
    tmux select-pane -t $session:1.1
fi

# If -d is specified, any other clients attached to the session are detached. -c working-directory
tmux attach-session -t $session

echo "${log_prefix} session ${session} is created"

