#!/bin/bash

K3S_VERSION=v1.0.0
#curl -s https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash

#docker volume create local_registry
#docker container run -d --name registry.local -v local_registry:/var/lib/registry --restart always -p 5000:5000 registry:2

mkdir -p ~/.k3d
cat <<EOT > ~/.k3d/registries.yaml
mirrors:
  "registry.local:5000":
    endpoint:
    - http://registry.local:5000
EOT

k3d create --volume ~/.k3d/registries.yaml:/etc/rancher/k3s/registries.yaml --image rancher/k3s:${K3S_VERSION} --publish 8080:80

docker network connect k3d-k3s-default registry.local

echo "aldonu ankoraŭ '127.0.0.1 registry.local' al /etc/hosts !"


