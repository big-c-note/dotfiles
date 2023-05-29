# Dot Files

How to set up a new machine with my dotfiles manually.
Ansible playbooks for ubuntu server are hete.

## Installation

[Mostly based on this link.](https://www.atlassian.com/git/tutorials/dotfiles)

```bash
# Ensure you have an acceptable version of python system-wide.

# Ensure basic dependancies are installed.
sudo apt install git curl zsh -y

# Ensure vim works and is compiled with python3 support.
# On Ubuntu, I git cloned the source and ran the following configure.
./configure --with-python3-command=python3.7 \
            --with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu \
	    --enable-python3interp
# Consider using [homebrew](https://brew.sh/) on Mac OS.
vim --version
brew install vim

# You'll need to close your teminal and restart. You should be good.
vim --version

# Install fzf.
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install 

# Ensure the repo has access to my private GitHub account. Generate a new key 
# or the computer like so:
ssh-keygen -t rsa -b 4096 -C ""

# Add new key to GitHub account: https://github.com/settings/ssh/new
less $HOME/.ssh/id_rsa.pub

# Install bare repo.
git clone --bare git@github.com:big-c-note/dot_files.git $HOME/.dot

# Setup alias as a temporary measure (it's in the .aliases file).
alias dot='git --git-dir=$HOME/.dot/ --work-tree=$HOME'

# Move dotfiles from repo to home folder. Delete manually anything playing up.
dot checkout

# Prevent clutter.
dot config --local status.showUntrackedFiles no 

# Pull and provide any changes.
dot pull origin master; dot checkout

# https://github.com/ggreer/the_silver_searcher
sudo apt-get install silversearcher-ag
# On Mac OS you can use homebrew.
brew install the_silver_searcher

# You can install vim Plugins via a vim command.
:PlugInstall

# Make sure these installs are on your PATH.
# Also acceptable is to add them to a general-purpose environment.
pip3 install black
pip3 install mypy
pip3 install flake8

# Set up for rust [1].
# [1] https://github.com/dense-analysis/ale/blob/master/doc/ale-rust.txt
# `rust-analyzer` recommended to build from source into ~/.rust-analyzer
# Current debugging process [2].
# [2] https://bryce.fisher-fleig.org/debugging-rust-programs-with-lldb/
```

## Troubleshooting

``` bash
# Vim will use the system python3 (ensure its compiled with py3 support). Install pip3.
sudo apt install python3-pip

# To help debug, the following commainds will be helpful:
which python3
which pip3
vim --version  
:py3 import sys; print(sys.version)  # in vim
pip3 --version

# Make sure Vim is python3 compatible
vim --version 
# If so, what python version is it using? 
```
