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

# We do this first to ensure sudo works below when renaming the user.
# Otherwise the current container UID may not exist in the passwd database.
eval "$(fixuid -q)"

if [ "${DOCKER_USER-}" ] && [ "$DOCKER_USER" != "$USER" ]; then
  echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd > /dev/null
  # Unfortunately we cannot change $HOME as we cannot move any bind mounts
  # nor can we bind mount $HOME into a new home as that requires a privileged container.
  sudo usermod --login "$DOCKER_USER" coder
  sudo groupmod -n "$DOCKER_USER" coder

  USER="$DOCKER_USER"

  sudo sed -i "/${DOCKER_USER}/d" /etc/sudoers.d/nopasswd
fi
#dumb-init dockerd-rootless.sh


#export PATH=/home/${DOCKER_USER}/.local/bin:$PATH
#unshare -m -U /bin/bash
#nsenter -U --preserve-credentials -n -m -t $(cat $XDG_RUNTIME_DIR/docker.pid)


#  chown -R $USER $HOME

#dumb-init code-server


#dumb-init
$HOME/.local/bin/code-server "$@"
