#!/bin/bash

secrets=$(docker secret ls --filter name=voko-sesio. -q)
if [ ! -z "${secrets}" ]; then
    echo "# forigante malnovajn sekretojn voko-sesio.* ..."
    docker secret rm ${secrets}
fi

echo
echo "# metante novajn sekretojn..."
ftp_password=$(cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16})
ftp_user=sesio

echo ${ftp_password} | docker secret create voko-sesio.ftp_password -
echo ${ftp_user} | docker secret create voko-sesio.ftp_user -

docker secret ls --filter name=voko-sesio. 

