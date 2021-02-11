FROM node:latest AS node
FROM codercom/code-server:latest

#USER root

COPY --from=node /usr/local/ /usr/local/
COPY --from=node /opt/ /opt/

RUN for e in node npm yarn; do echo -n "${e} version: " && ${e} --version; done


COPY --from=docker:latest /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker/compose:debian-1.28.2 /usr/local/bin/docker-compose /usr/local/bin/docker-compose

#RUN sudo chmod +x /usr/local/bin/docker-compose
#COPY coder-docker-entrypoint.sh /usr/local/bin

#RUN set ex; chmod +x /usr/local/bin/coder-docker-entrypoint.sh

#RUN set ex; mv /usr/local/bin/coder-docker-entrypoint.sh /usr/local/bin
USER coder


#EXPOSE 8080

# start the app
#ENTRYPOINT ["coder-docker-entrypoint.sh"]
