#!/usr/bin/env zsh
################
#description  : bash functions to override or provide addtional details based on basic commands
#bash_version : 5.1.4(1)-release
#author	      : krishnam
################

function show_all_job_commands() {
  # Get a list of all job IDs
  local job_ids=$(jobs -l | awk '{print $1}' | tr -d '[[:punct:]]')

  # Check if there are any job IDs
  if [ -z "$job_ids" ]; then
    echo "No active jobs"
    return 1
  fi

  # Iterate over each job ID and display the full command
  for job_id in $job_ids; do
    # Get the process ID (PID) associated with the job ID
    local pid=$(jobs -p %"$job_id" | awk '{print $3}')

    # Use ps to display the full command for the PID
    local command=$(ps -p "$pid" -o command)

    # Print the job ID and the full command
    echo "Job $job_id command: $command"
  done
}

# like a pgrep for process (ps) filtering
function hgrep() {
    if [[ -z "$1" ]]; then
        echo "Usage: history-grep <pattern>"
        return 1
    fi
    # search from history record starting with 1
    history 0 | egrep -i "$1"
}

# The take command will create a new directory and change into it. take my-project replaces mkdir my-project && cd my-project
function take {
  mkdir -p $1 && cd $1
}

# undo the move: command comes handy in moving things back and forth in short time
function umv {
  mv $2 $1 
}

# copy the file content to clipboard
function fcp {
  pbcopy < $1
}

################################## PRINT START ##############################
# Showing Where You Are - show working directory
# print dir
function pdir {
  echo $CS_bblue"Logical Path:$CS_reset $(command pwd -L )" # print working dir logical path
	echo $CS_bgreen"Physical Path:$CS_reset $(command pwd -P )" # physical location - useful for syslink
}

# P: Finding and Running Commands

# Describe Commands
# type command searches your environment (including aliases, keywords, functions, builtins, directories in $PATH, and the command hash table)
# which command is similar but only searches your $PATH
# apropos searches manpage names and descriptions for regular expressions supplied as arguments. This is incredibly useful when you don’t remember the name of the command you need.
#
# Option: -s search in manpages

function dcmd {
  echo $CS_bcyan"[whence]:$CS_byellow $(whence $1)"$CS_reset
  echo $CS_bcyan"[type]  :$CS_byellow $(type $1)"$CS_reset
  echo $CS_bcyan"[which] :$CS_byellow $(which $1)"$CS_reset
  echo $CS_bcyan"[version] :$CS_byellow $($1 -version)"$CS_reset
  while getopts "s" opt
  do
    case $opt in
      s) echo $CS_bcyan"[apropos]:$CS_reset $(apropos $1)";;
    esac
  done
}

# describe file stat
function dfile {
  echo $CS_bcyan"[ls]$CS_reset $(ls -l $1)"
  echo $CS_byellow"[file]$CS_reset $(file $1)"
	echo $CS_bgreen"[stat]$CS_reset $(stat $1)"
}

################################## PRINT END ##############################

# source all envs, aliases, & functions
function zshs {

  if [ -d ~/hrt/boot/env ]; then
    for efile in ~/hrt/boot/env/*sh
    do
      echo $LOG_TS"Sourcing ${efile} ..."
      source $efile
    done
    unset efile
  fi

  if [ -d ~/hrt/boot/alias ]; then
    for afile in ~/hrt/boot/alias/*sh
    do
      echo $LOG_TS"Sourcing ${afile} ..."
      source $afile
    done
    unset afile
  fi
  
 if [ -f ~/hrt/pvt/alias.zsh ]; then
  echo $LOG_TS"Sourcing aliases from private dir ..." 
  source ~/hrt/pvt/alias.zsh
 fi
  
 if [ -d ~/hrt/boot/func ]; then
    for ffile in ~/hrt/boot/func/*sh
    do
      echo $LOG_TS"Sourcing ${ffile} ..."
      source $ffile
    done
    unset ffile
  fi
}


# source all envs, aliases, & functions
function sbash {

  if [ -d ~/.myenv ]; then
    for efile in ~/.myenv/*.bash
    do
      echo $LOG_TS"Sourcing ${efile} ..."
      source $efile
    done
    unset efile
  fi

  if [ -d ~/.myalias ]; then
    for afile in ~/.myalias/*.bash
    do
      echo $LOG_TS"Sourcing ${afile} ..."
      source $afile
    done
    unset afile
  fi

  if [ -d ~/.myfunc ]; then
    for ffile in ~/.myfunc/*.bash
    do
      echo $LOG_TS"Sourcing ${ffile} ..."
      source $ffile
    done
    unset ffile
  fi
}

