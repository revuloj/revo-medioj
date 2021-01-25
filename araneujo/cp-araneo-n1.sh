#!/bin/bash

araneo_id=$(docker ps --filter name=araneujo_araneo -q)
target=/usr/local/apache2/htdocs/revo/$2

echo "kopiante $1 al ${araneo_id}:${target}"

docker cp $1 ${araneo_id}:${target}
docker exec ${araneo_id} bash -c "chown root.root ${target}; ls -l ${target}"
