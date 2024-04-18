
#!/bin/bash

# Tool to list and select ssh connections set in the ~/.ssh/config file.

config_file="$HOME/.ssh/config"
remote_hosts=("Quit")
config_found=false

if [[ -e $config_file ]]; then
  while IFS= read -r line; do
    trimmed_line=$(echo "$line" | awk '{$1=$1;print}')
    
    if [[ $trimmed_line =~ ^Host[[:space:]]+(.*) ]]; then
      host_spec="${BASH_REMATCH[1]}"
      
      # Check for wildcard host
      if [[ "$host_spec" == "*" ]]; then
        continue  # Skip wildcard host, as it applies globally
      fi
      
      remote_hosts+=("$host_spec")
    fi
  done < "$config_file"
  
  config_found=true
else
  echo "No config found in $HOME/.ssh/!"
fi

if [ "$config_found" = true ]; then
  PS3='Select connection: '
  select host in "${remote_hosts[@]}"; do
    if [ "$host" = "Quit" ]; then
      break
    else
      if [ "$TERM_PROGRAM" = tmux ]; then
        tmux new-window
        tmux rename-window "$host"
        tmux send-keys -t "$host" "ssh $host" Enter
      else
        tmux new-session -d -s "$host"
        tmux send-keys -t "$host" "ssh $host" Enter
        tmux attach -t "$host"
      fi
      break
    fi
  done
fi

