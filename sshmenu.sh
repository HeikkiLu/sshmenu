#!/bin/bash

# Tool to list and select ssh connections set in the ~/.ssh/config file.

input="$HOME/.ssh/config"
remote_hosts=()
headers="# [a-zA-Z]+"

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
  echo "Config does not exist in $HOME/.ssh/, please create one first!"
fi

remote_hosts+=("Quit")

PS3='Select connection '
select host in "${remote_hosts[@]}"
do
  if [ "$host" = "Quit" ]
    then break
  fi
  if [ "$host" ]
    then $(ssh $host);  
  fi
done 
