#!/bin/bash
set -ea


#PATH=/home/coder/bin:/sbin:/usr/sbin:$PATH dockerd-rootless.sh
#[INFO] Make sure the following environment variables are set (or add them to ~/.bashrc):
# WARNING: systemd not found. You have to remove XDG_RUNTIME_DIR manually on every logout.

#PATH=/home/coder/bin:/sbin:/usr/sbin:$PATH
#export XDG_RUNTIME_DIR=/home/${DOCKER_USER}/.docker/run
#export PATH=/home/${DOCKER_USER}/bin:$PATH
#export DOCKER_HOST=unix:///home/${DOCKER_USER}/.docker/run/docker.sock


export PATH=/home/${USER}/bin:/sbin:/usr/sbin:$PATH



PATH=/home/${USER}/bin:/sbin:/usr/sbin:$PATH


#dumb-init dockerd-rootless.sh


#export PATH=/home/${DOCKER_USER}/.local/bin:$PATH
#unshare -m -U /bin/bash
#nsenter -U --preserve-credentials -n -m -t $(cat $XDG_RUNTIME_DIR/docker.pid)


#  chown -R $USER $HOME

#dumb-init code-server


#dumb-init
$HOME/.local/bin/code-server "$@"
