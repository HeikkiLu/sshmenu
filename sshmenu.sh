#!/bin/bash

# Tool to list and select ssh connections set in the ~/.ssh/config file.

input="$HOME/.ssh/config"
remote_hosts=("Quit")
config_found=true

if [[ -e $input ]]; then
  while read -r line;
  do
    if [[ $line =~ "Host " ]]; then
      prefix="Host "
      conn=${line#"$prefix"}
      remote_hosts+=($conn)
    fi
  done < "$input"
else
  echo "No config found in $HOME/.ssh/!";
  config_found=false;
fi

if [ "$config_found" = true ]; then
  PS3='Select connection '
  select host in "${remote_hosts[@]}"
  do
    if [ "$host" = "Quit" ]
      then break
    else
      tmux new-session -d -s "$host";
      tmux send-keys -t "$host" "ssh $host" Enter;
      tmux attach -t "$host"
      break; 
    fi
  done  
fi

