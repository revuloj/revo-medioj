#!/bin/bash

ftp_password=$(cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16} | base64 )

echo "# metante novajn sekretojn..."

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: voko-sesio
type: Opaque
data:
  voko-sesio.ftp_password: ${ftp_password}
EOF
