#!/bin/bash

# ni komprenas preparo | docker | servilo |index
# kaj supozas "docker", se nenio donita argumente
target="${1:-araneo}"

case $target in

zip)
    echo "./formiko-exec.sh formiko srv-servo-formikujo... (povas daŭri longe!)"
    ./formiko-exec.sh formiko srv-servo-formikujo    
    ;;
araneo)
    echo "Aktualigu la vortaron per ZIP-dosiero el loka Formikujo"    
    echo "Tion vi povas antaŭe krei per celo zip)"

    araneo_id=$(docker ps --filter name=araneujo_araneo -q)
    formiko_id=$(docker ps --filter name=formikujo_formiko -q)

    zip=revohtml_$(date '+%Y-%m-%d').zip
    ht_dir=/usr/local/apache2/htdocs
    
    docker cp ${formiko_id}:/home/formiko/tgz/${zip} .
    docker cp ./${zip} ${araneo_id}:${ht_dir}/
    docker exec -u0 ${araneo_id} unzip -qo -d ${ht_dir} ${ht_dir}/${zip}
    ;;
esac
