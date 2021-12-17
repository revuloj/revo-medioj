#!/bin/bash

# vi povas doni kiel argumenton 'update-db' aŭ 'redaktantoj'
# se vi ne donas argumenton ni supozas 'update-db'
target="${1:-update-db}"
env_file=../../etc/.env
compose_file=docker-compose-srv.yml

docker-compose -f ${compose_file} --env-file ${env_file} exec cetonio bin/instalo.sh ${target}

