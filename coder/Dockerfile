FROM ubuntu:focal

USER root
#ENV SKIP_IPTABLES true
#ENV DOCKER_USER dockremap
ARG DOCKER_USER
ARG U_UID
ARG U_GID
#ENV TZ=Asia/Ho_Chi_Minh
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
	  apt-get update && \
    apt-get -y install \
		btrfs-progs \
		e2fsprogs \
		iptables \
		openssl \
		uidmap \
		xfsprogs \
		xz-utils \
		pigz \
    wget \
    iproute2 \
    kmod   \ 
sudo \ 
curl \
dumb-init \ 
git \ 
sudo \
    openssh-client \
procps \
    && rm -rf /var/lib/apt/lists/*

RUN echo whoami $(id -u) $(id -g)
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.conf && \
    echo 'user.max_user_namespaces=28633' >> /etc/sysctl.conf && \
   echo "options overlay permit_mounts_in_userns=1" >> /etc/modprobe.d/rootless.conf

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN sudo adduser --gecos '' --disabled-password coder


#RUN ARCH="$(dpkg --print-architecture)" && \
#    curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - && \
#    chown root:root /usr/local/bin/fixuid && \
#    chmod 4755 /usr/local/bin/fixuid && \
#    mkdir -p /etc/fixuid && \
#    printf "user: ${DOCKER_USER}\ngroup: ${DOCKER_USER}\n" > /etc/fixuid/config.yml
# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
#RUN set -eux; \
#	addgroup --system dockremap; \
#	adduser --system --ingroup dockremap dockremap; \
#	echo 'dockremap:165536:65536' >> /etc/subuid; \
#	echo 'dockremap:165536:65536' >> /etc/subgid

#RUN sudo addgroup --gid ${U_GID} ${DOCKER_USER}
#RUN sudo adduser --gecos '' --disabled-password --gid ${U_GID} --uid ${U_UID} ${DOCKER_USER} && \
#    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
RUN id -u
RUN whoami
RUN cat /etc/subuid
RUN cat /etc/subgid
# This way, if someone sets $DOCKER_USER, docker-exec will still work as
# the uid will remain the same. note: only relevant if -u isn't passed to
# docker-run.
#USER 1000
ENV USER ${DOCKER_USER}
USER ${DOCKER_USER}
WORKDIR /home/${DOCKER_USER}
#RUN sudo chmod 666 /var/run/docker.sock


#RUN mkdir projects
RUN id -u
RUN whoami
RUN cat /etc/subuid
RUN cat /etc/subgid

RUN curl -fsSL https://get.docker.com/rootless | sh && \
    echo "export PATH=/home/${DOCKER_USER}/bin:/sbin:/usr/sbin:$PATH" >> ~/.bashrc && \
    #echo "dockerd-rootless.sh --userns-remap=${DOCKER_USER}" >> ~/.bashrc && \
    echo "export XDG_RUNTIME_DIR=/home/${DOCKER_USER}/.docker/run" >> ~/.bashrc && \
    echo "export PATH=/home/${DOCKER_USER}/bin:$PATH" >> ~/.bashrc  && \
    echo "export DOCKER_HOST=unix:///home/${DOCKER_USER}/.docker/run/docker.sock" >> ~/.bashrc

#USER root
RUN curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o ~/bin/docker-compose && \
    chmod +x ~/bin/docker-compose

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
RUN NVM_DIR="$HOME/.nvm"


# Install Coder
RUN  echo "**** install code-server ****" && \
     if [ -z ${CODE_RELEASE+x} ]; then \
     CODE_RELEASE=$(curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]'); \
      fi && \
      CODE_VERSION=$(echo "$CODE_RELEASE" | awk '{print substr($1,2); }') && \
      mkdir -p ~/.local/lib ~/.local/bin && \
      curl -fL https://github.com/cdr/code-server/releases/download/v"$CODE_VERSION"/code-server-"$CODE_VERSION"-linux-amd64.tar.gz \
      | tar -C ~/.local/lib -xz && \
      mv ~/.local/lib/code-server-"$CODE_VERSION"-linux-amd64 ~/.local/lib/code-server-"$CODE_VERSION" && \
      ln -s ~/.local/lib/code-server-"$CODE_VERSION"/bin/code-server ~/.local/bin/code-server && \
      echo "export PATH=~/.local/bin:$PATH" >> ~/.bashrc && \
      echo "code-server --auth none --bind-addr 0.0.0.0:8080" >> ~/.bashrc

RUN mkdir -p /home/${DOCKER_USER}/.config
RUN mkdir -p /home/${DOCKER_USER}/.local/share/code-server/User/globalStorage
RUN mkdir -p /home/${DOCKER_USER}/.local/share/code-server/certs
RUN mkdir -p /home/${DOCKER_USER}/.local/share/code-server/extensions
#RUN chown -R $DOCKER_USER /home/$DOCKER_USER

# Allows code-server to listen on port 443.
#RUN sudo setcap cap_net_bind_service=+ep /home/$DOCKER_USER/.local/lib/code-server/lib/node

EXPOSE 8080
#ENTRYPOINT [ "/home/coder/.local/bin/code-server" ]
CMD [ "/bin/bash" ]
