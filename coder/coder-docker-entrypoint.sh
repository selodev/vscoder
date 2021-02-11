#!/usr/bin/env bash

set -ea

# We do this first to ensure sudo works below when renaming the user.
# Otherwise the current container UID may not exist in the passwd database.
eval "$(fixuid -q)"


# Replaces "cert: false" with "cert: true" in the code-server config.
sudo sed -i.bak 's/cert: false/cert: true/' /root/.config/code-server/config.yaml
# Replaces "bind-addr: 127.0.0.1:8080" with "bind-addr: 0.0.0.0:443" in the code-server config.
sudo sed -i.bak 's/bind-addr: 127.0.0.1:8080/bind-addr: 0.0.0.0:443/' /root/.config/code-server/config.yaml

# Allows code-server to listen on port 443.
sudo setcap cap_net_bind_service=+ep /usr/lib/code-server/lib/node

#sudo systemctl restart code-server@$USER

dumb-init /usr/bin/code-server "$@"

# Execute the rest of your ENTRYPOINT and CMD as expected.
#exec "$@"
