#!/bin/bash

araneo_id=$(docker ps --filter name=araneujo_araneo -q)
araneo_host=0.0.0.0
ports=$(docker service ls -f name=araneujo_araneo --format '{{.Ports}}')
ip_port=${ports%->*}
pnum=${ip_port#*:}

abelo_id=$(docker ps --filter name=araneujo_abelo -q)
  
