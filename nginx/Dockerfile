FROM nginx:latest

# Nginx execute all shell files within docker-entrypoint.d automatically.
COPY nginx-reload-entrypoint.sh /docker-entrypoint.d/

RUN set x; chmod +x /docker-entrypoint.d/nginx-reload-entrypoint.sh
