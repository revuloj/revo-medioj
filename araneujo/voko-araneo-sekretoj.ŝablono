#!/bin/bash

secrets=$(docker secret ls --filter name=voko-araneo. -q)
if [ ! -z ${secrets} ]; then
    echo "# forigante malnovajn sekretojn voko-araneo.* ..."
    docker secret rm ${secrets}
fi

echo
echo "# metante novajn sekretojn..."
cgi_password=$(cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16})
echo ${cgi_password} | docker secret create voko-araneo.cgi_password -

docker secret ls --filter name=voko-araneo. 

