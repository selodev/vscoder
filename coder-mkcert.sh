CURRENT_UID=$(id -u):$(id -g) \
U_UID=$(id -u) \
U_GID=$(id -g) \
docker-compose -f docker-compose.local.yaml up "$@"
