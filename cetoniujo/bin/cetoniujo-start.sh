#!/bin/bash

env_file=${HOME}/etc/.envfile
compose_file=docker-compose-srv.yml

docker-compose -f ${compose_file} --env-file {$ENV_FILE} up -d --remove-orphans
docker-compose -f ${compose_file} logs -f
