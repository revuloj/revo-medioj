#!/bin/bash

# vi povas doni kiel argumenton 'update-db' aŭ 'redaktantoj'
# se vi ne donas argumenton ni supozas 'update-db'
target="${1:-update-db}"
compose_file=docker-compose-srv.yml

docker-compose -f ${compose_file} exec cetonio bin/instalo.sh ${target}

