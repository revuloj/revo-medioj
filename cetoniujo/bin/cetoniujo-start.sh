#!/bin/bash

env_file=${HOME}/etc/.env
compose_file=docker-compose-srv.yml

docker-compose -f ${compose_file} --env-file ${env_file} up -d --remove-orphans
docker-compose -f ${compose_file} logs -f
