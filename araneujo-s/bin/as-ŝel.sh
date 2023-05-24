#!/bin/bash

araneo_id=$(docker ps --filter name=araneujo_araneo -q)

docker exec -it ${araneo_id} bash