#!/bin/bash

deployment=$1
istioctl kube-inject -f ../${deployment}-deployment.yaml | kubectl apply -f -