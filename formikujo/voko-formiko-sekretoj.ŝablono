#!/bin/bash

keyfile=${HOME}/.ssh/formiko
echo "kreante ŝlosilparon por interkomunikado..."
ssh-keygen -t rsa -b 3072 -f ${keyfile} -C "formiko" -N ""

echo "# forigante malnovajn sekretojn voko-formiko.* ..."
secrets=$(docker secret ls --filter name=voko-formiko. -q)
docker secret rm ${secrets}

echo
echo "# metante novajn sekretojn..."
cat ${keyfile} | docker secret create voko-formiko.ssh_key -
### se ne ne bezonas testi de docker-gastiganto
### ni povus forigi la ŝlosilon:
### rm ${keyfile}

docker secret ls --filter name=voko-formiko. 
