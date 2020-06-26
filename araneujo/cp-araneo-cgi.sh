#!/bin/bash

araneo_id=$(docker ps --filter name=araneujo_araneo -q)

echo "kopiante $1 al ${araneo_id}:/usr/local/apache2/cgi-bin/$2"

docker cp $1 ${araneo_id}:/usr/local/apache2/cgi-bin/$2
docker exec ${araneo_id} bash -c "chown root.root /usr/local/apache2/cgi-bin/*; chmod 755 /usr/local/apache2/cgi-bin/*.pl; ls -l /usr/local/apache2/cgi-bin/*"