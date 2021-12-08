#!/bin/bash

#cmd="${1:--h}"
compose_file=docker-compose-srv.yml
docker-compose -f ${compose_file} $@