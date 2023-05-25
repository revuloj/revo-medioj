#!/bin/bash

# ni komprenas preparo | docker | servilo |index
# kaj supozas "docker", se nenio donita argumente
target="${1:-araneo}"

case $target in

zip)
    echo "bin/fs-formiko.sh formiko srv-servo-formikujo... (povas daŭri longe!)"
    bin/fs-formiko.sh formiko srv-servo-formikujo    
    ;;
db)
    echo "bin/fs-formiko.sh formiko sql-tuto... (povas daŭri iom!)"
    bin/fs-formiko.sh formiko sql-tute    
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
cetonio-db)
    echo "Aktualigu la datumbazon en Cetonio per ZIP-dosiero el loka Formikujo"    
    echo "Tion vi povas antaŭe krei per celo db)"

    cetonio_id=$(docker ps --filter name=cetoniujo_cetonio -q)
    formiko_id=$(docker ps --filter name=formikujo_formiko -q)

    zip=revosql-inx_$(date '+%Y-%m-%d').zip
    tmp_dir=/home/cetonio/tmp
    sql_dir=/home/cetonio/sql

    docker cp ${formiko_id}:/home/formiko/tgz/${zip} .
    docker cp ./${zip} ${cetonio_id}:${tmp_dir}/

    docker exec -u1088 ${cetonio_id} unzip -qo -d ${tmp_dir} ${tmp_dir}/${zip}
    docker exec -u1088 ${cetonio_id} cp ${tmp_dir}/revo-inx.db ${sql_dir}/revo-inx.db
esac
