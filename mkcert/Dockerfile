FROM golang:1.12-alpine

WORKDIR /root/.local/share/mkcert

RUN apk --no-cache add git

RUN cd /go && \
    go get -u github.com/FiloSottile/mkcert && \
    cd src/github.com/FiloSottile/mkcert && \
    go build -o /bin/mkcert
    
#Check if cert files exists
COPY docker-entrypoint.sh /usr/local/go/bin/

RUN set -ex; chmod +x /usr/local/go/bin/docker-entrypoint.sh

# start the app
ENTRYPOINT [ "docker-entrypoint.sh" ]
   
