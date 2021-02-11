#!/bin/bash

# Set environment variables from .env file

if [ -f .env ]; then
  echo "INFO: Found the .env file"
  source .env
  export CURRENT_UID=$(id -u):$(id -g)
else
    echo "ERROR: Could not find the .env file?"
    exit 1;
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

domains=$(echo ${CERT_DOMAINS} | sed "s/,/ /g");
rsa_key_size=4096
local_certbot_path="./certbot/letsencrypt"
email=${CERT_EMAIL} # Adding a valid address is strongly recommended
staging=1 # Set to 1 if you're testing your setup to avoid hitting request limits

if [ -d "$local_certbot_path" ]; then
  read -p "Existing data found for $domains. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi

if [ ! -e "$local_certbot_path/options-ssl-nginx.conf" ] || [ ! -e "$local_certbot_path/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$local_certbot_path"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$local_certbot_path/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$local_certbot_path/ssl-dhparams.pem"
  echo
fi

echo "### Requesting Let's Encrypt certificate for $domains ..."
#Join $domains to -d args
domain_args=""
for domain in $domains; do
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

echo "### Creating $staging_arg certificate(s) for $domains ..."
docker-compose run -p 80:80 --rm --entrypoint "\
  certbot certonly --standalone \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal \
    " certbot
echo

echo "### Starting certbot, nginx and coder..."
docker-compose up --force-recreate -d nginx certbot coder
echo

#echo "### Reloading nginx ..."
#docker-compose exec coder-nginx nginx -s reload

