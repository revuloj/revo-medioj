#!/bin/bash

cgi_password=$(cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16} | base64)

echo
echo "# metante novajn sekretojn..."

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: voko-araneo
type: Opaque
data:
  voko-araneo.cgi_password: ${cgi_password}
EOF
