set -ex
apk add --no-cache tmux zsh 
apk add --no-cache python3 
apk add --no-cache py3-pip
# pip3 install --user tmuxp
pip install --user -e git+https://github.com/tmux-python/tmuxp.git#egg=tmuxp
# ln -s /root/.local/bin/tmuxp /usr/local/bin/tmuxp
