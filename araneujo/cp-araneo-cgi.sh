#!/bin/bash

araneo_id=$(docker ps --filter name=araneujo_araneo -q)
target=/usr/local/apache2/cgi-bin

echo "kopiante $1 al ${araneo_id}:${target}/$2"

docker cp $1 ${araneo_id}:${target}/$2
docker exec ${araneo_id} bash -c "chown root.root ${target}/*; chmod 755 ${target}/*.pl; ls -l ${target}/$2"