#!/bin/bash

formiko_id=$(docker ps --filter name=formikujo_formiko -q)
target=/home/formiko/revo

echo "kopiante $1 al ${formiko_id}:${target}/$2"

docker cp $1 ${formiko_id}:${target}/$2
#docker exec ${formiko_id} bash -c "chown root.root ${target}/*; ls -l ${target}/$2"
docker exec ${formiko_id} bash -c "chown formiko.formiko ${target}/*; ls -l ${target}/$2"