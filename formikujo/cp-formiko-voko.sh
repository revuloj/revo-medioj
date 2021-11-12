#!/bin/bash

docker_id=$(docker ps --filter name=formikujo_formiko -q)
target=/home/formiko/voko/$2

echo "kopiante $1 al ${docker_id}:${target}"

docker cp $1 ${docker_id}:${target}
#docker exec ${docker_id} bash -c "chown root.root ${target}; ls -l ${target}"
docker exec ${docker_id} bash -c "ls -l ${target}"
