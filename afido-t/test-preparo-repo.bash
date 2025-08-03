#!/bin/bash

# set -x

#if [[ -z "$TEST_RETADRESO" ]]; then
#  echo "Vi devas antaŭdifini variablon TEST_RETADRESO por doni unu retadreson kien sendiĝas raportoj dum testoj."
#  exit 1
#fi 

stack=afidotesto

### Ĉu Afido ktp. estas aktivaj? Ni bezonas ĝian n-ron...
# afido_id=$(docker ps --filter name=${stack}_afido -q) && echo "afido: ${afido_id}"

# Plibonigu: kiel ni povas montri tion en "bats"?
# if [ "${afido_id}" = "" ]; then echo "afido ne aktiva!" 1>&2; exit 1; fi

# ni uzas volumes: en docker-compose anstatataŭe
#docker cp bin/create_test_repo.sh ${afido_id}:/usr/local/bin/
#docker cp bin/create_test_gist.sh ${afido_id}:/usr/local/bin/

# tion ni jam faras en test-preparo, do ne denove tie ĉi?
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/dict/gists"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/dict/xml"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/dict/tmp"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/dict/log"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/dict/revo-fonto"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/test-repo"

#docker exec -it -u1074 ${afido_id} bash -c "create_test_repo.sh"
#docker exec -it -u1074 ${afido_id} bash -c "create_test_gist.sh ${TEST_RETADRESO}"

docker compose run --rm afido create_test_repo.sh



