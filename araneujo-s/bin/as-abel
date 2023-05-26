#!/bin/bash

# eltajpas la db-parametrojn por pli facile plenigi la kampojn en abelisto
# tiuj parametroj estas difinitaj precipe tra
# docker-compose resp. la sekreto por la pasvorto


# ni devas eltrovi la pasvorton...
araneo_id=$(docker ps --filter name=araneujo_araneo -q) && echo "# (Araneo: ${araneo_id})"
PWD=$(exec docker exec ${araneo_id} cat /run/secrets/voko-abelo.mysql_password)

echo "SERVER: abelo"
echo "MYSQL_DATABASE: db314802x3159000"
echo "MYSQL_USER: s314802_3159000"
echo "MYSQL_PASSWORD: $PWD"

