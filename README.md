# sshmenu
Simple script to connect to ssh hosts found in your `.ssh/config` file.

Script creates a new tmux session, names it according to the ssh host and connects to the host in the session. If tmux session already exist, script creates a new window, renames it and connects to the host in the window.

Requirements
 - [tmux](https://github.com/tmux/tmux/wiki) (>3.2v)
