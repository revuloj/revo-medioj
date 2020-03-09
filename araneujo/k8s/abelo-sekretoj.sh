#!/bin/bash

mysql_root_password=$(cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16} | base64)
mysql_password=$(cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16} | base64)

echo
echo "# metante novajn sekretojn..."

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: voko-abelo
type: Opaque
data:
  voko-abelo.mysql_root_password: ${mysql_root_password}
  voko-abelo.mysql_password: ${mysql_password}
EOF