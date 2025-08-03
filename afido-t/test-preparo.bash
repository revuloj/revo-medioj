#!/bin/bash

#set -x

stack=afidotesto

### Ĉu Afido ktp. estas aktivaj? Ni bezonas ĝian n-ron...
#afido_id=$(docker ps --filter name=${stack}_afido -q) && echo "afido: ${afido_id}"

# Plibonigu: kiel ni povas montri tion en "bats"?
#if [ "${afido_id}" = "" ]; then echo "afido ne aktiva!" 1>&2; exit 1; fi

# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/dict/gists"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/dict/xml"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/dict/tmp"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/dict/log"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/test-repo"
# docker exec -it -u1074 ${afido_id} bash -c "rm -rf /home/afido/revo-fonto"

## docker service update --args "rm -rf /home/afido/dict/gists /home/afido/dict/xml /home/afido/dict/tmp /home/afido/dict/log /home/afido/test-repo /home/afido/revo-fonto" ${stack}_afido
## 
## docker service scale ${stack}_afido=1
## 
## docker service update --rollback ${stack}_afido

docker compose run --rm --entrypoint="" --remove-orphans afido rm -rf /home/afido/dict/gists /home/afido/dict/xml /home/afido/dict/tmp /home/afido/dict/log /home/afido/test-repo /home/afido/revo-fonto




