#!/bin/bash

afido_id=$(docker ps --filter name=afidotesto_afido -q)
target=/usr/local/bin

echo "kopiante $1 al ${afido_id}:${target}/$2"

docker cp $1 ${afido_id}:${target}/$2
#docker exec ${afido_id} bash -c "chown root.root ${target}/*; ls -l ${target}/$2"
docker exec ${afido_id} bash -c "ls -l ${target}/$2"

