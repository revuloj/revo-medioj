#!/bin/bash

k3d create --volume /home/${USER}/.k3d/registries.yaml:/etc/rancher/k3s/registries.yaml \
  --publish 8080:80 --image=docker.io/rancher/k3s:v1.0.0

k3d get-kubeconfig

#docker network connect k3d-k3s-default registry.local