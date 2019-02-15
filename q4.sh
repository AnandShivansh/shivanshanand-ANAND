tmux new-session -s mysession -d 'htop'
tmux splitw -v 'sudo tcpdump'
tmux select-pane -t 0
tmux split -h
tmux clock -t mysession
tmux select-pane -t 2
tmux attach-session -t mysession
