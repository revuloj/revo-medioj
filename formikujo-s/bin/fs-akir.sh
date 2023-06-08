#!/bin/bash

label="${1:-latest}"

echo "Ni ŝargas la procezujojn por Formikujo el la deponejo ĉe Github (Ghcr), etikedo: '${label}'"

docker pull ghcr.io/revuloj/voko-formiko/voko-formiko:${label}
docker pull ghcr.io/revuloj/voko-afido/voko-afido:${label}

# alinomu por loka uzo
docker tag ghcr.io/revuloj/voko-formiko/voko-formiko:${label} voko-formiko
docker tag ghcr.io/revuloj/voko-afido/voko-afido:${label} voko-afido

