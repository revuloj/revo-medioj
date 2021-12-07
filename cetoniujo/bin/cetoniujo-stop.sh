#!/bin/bash

compose_file=docker-compose-srv.yml
docker-compose -f ${compose_file} down