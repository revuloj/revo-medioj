#!/bin/bash

stack=formikotesto
#afido_id=$(docker ps --filter name=${stack}_afido -q) && echo "Afido: ${afido_id}"
#tomocero_id=$(docker ps --filter name=${stack}_tomocero -q) && echo "Tomocero: ${tomocero_id}"

# forigu processmail.test.pl
#docker exec -u0 ${afido_id} rm /usr/local/bin/processmail.test.pl    
#
## forigu test007 el CVS
#test007_cvs=$(docker  exec -u1074 ${afido_id} ls -l /home/afido/dict/xml/test007.xml | tail -1)
#echo "cvs: ${test007_cvs##* }"
#if [[ "${test007_cvs##* }" == *"test007.xml"* ]]; then
#    echo "Forigas test007.xml el xml kaj CVS"
#    docker  exec -u1074 ${afido_id} bash -c "cd /home/afido/dict/xml; rm test007.xml; cvs rm test007.xml; cvs ci -m'forigi 007' test007.xml"
#fi
#
## forigu test007 el Git
#test007_git=$(docker  exec -u1074 ${afido_id} ls -l /home/afido/dict/revo-fonto/revo/test007.xml | tail -1)
#echo "git: ${test007_git##* }"
#if [[ "${test007_git##* }" == *"test007.xml"* ]]; then
#    echo "Forigas test007.xml el Git"
#    docker  exec -u1074 ${afido_id} bash -c "cd dict/revo-fonto/revo; rm test007.xml; git rm test007.xml; git commit -m'forigi 007' test007.xml"
#fi