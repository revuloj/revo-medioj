#!/bin/bash


export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')

#export SECURE_INGRESS_PORT=31325
#export INGRESS_HOST=172.17.0.3
#export INGRESS_PORT=31679

echo "http://$INGRESS_HOST:$INGRESS_PORT/revo"
curl -I -HHost:example.com http://$INGRESS_HOST:$INGRESS_PORT/revo