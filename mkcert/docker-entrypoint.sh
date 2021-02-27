#!/bin/sh

set -e

createCerts(){
for i in $(echo ${DOMAINS} | sed "s/,/ /g"); do
      mkcert $i; mkcert -pkcs12 $i;
   
done
}
dir="/root/.local/share/mkcert"
if [ -z "$(ls -A -- "$dir")" ]; then
    createCerts wait $!&& mkcert -install; wait $! && chmod +r *.* &&  exit; #tail -f -n0 /etc/hosts
else
    echo "Existing Certs Found. Skipped mkcert.";
    exit;
fi

# Execute the rest of your ENTRYPOINT and CMD as expected.
