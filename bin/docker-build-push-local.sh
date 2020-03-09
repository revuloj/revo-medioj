#!/bin/bash

rootdir=../
img=$1

cd $root_dir/$img
docker build -t $img .
docker tag $img registry.local:5000/$img
docker push registry.local:5000/$img
cd -
