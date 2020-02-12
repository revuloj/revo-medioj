#!/bin/bash

keyfile=${HOME}/.ssh/formiko

if [ ! -e ${keyfile} ]; then
  echo "kreante ŝlosilparon por interkomunikado..."
  ssh-keygen -t rsa -b 3072 -f ${keyfile} -C "formiko" -N ""
fi  

echo
echo "# metante novan sekreton..."
ssh_key=$(cat ${keyfile} | base64 -w 0)

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: voko-formiko
type: Opaque
data:
  voko-formiko.ssh_key: ${ssh_key}
EOF

