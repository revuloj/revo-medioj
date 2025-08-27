#!/bin/bash

stack=afidotesto

### Ĉu Afido ktp. estas aktivaj? Ni bezonas ĝian n-ron...
cetonio_id=$(docker ps --filter name=${stack}_cetonio -q) && echo "cetonio: ${cetonio_id}"

# Plibonigu: kiel ni povas montri tion en "bats"?
if [ "${cetonio_id}" = "" ]; then echo "cetonio ne aktiva!" 1>&2; exit 1; fi

# export TEST_RETADRESO=${TEST_RETADRESO}
docker exec -i -u1088 ${cetonio_id} ./bin/instalo.sh kreu-db
insert_red="DELETE FROM redaktanto; DELETE FROM retposhto; INSERT INTO redaktanto(red_id,nomo) VALUES (0,'test');INSERT INTO retposhto(red_id,numero,retposhto) VALUES (0,0,'${TEST_RETADRESO}');SELECT * FROM redaktanto;SELECT * FROM retposhto;"

echo "${insert_red}" | docker exec -i ${cetonio_id} sqlite3 /home/cetonio/sql/redaktantoj.db
#echo "SELECT * FROM redaktanto;SELECT * FROM retposhto;" | docker exec -i ${cetonio_id} sqlite3 /home/cetonio/sql/redaktantoj.db
cat $(pwd)/bin/create_test_submetoj_cetonio.sql | envsubst '${TEST_RETADRESO}' | docker exec -i ${cetonio_id} sqlite3 /home/cetonio/sql/submetoj.db


