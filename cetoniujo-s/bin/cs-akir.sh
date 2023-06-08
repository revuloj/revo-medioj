#!/bin/bash

label="${1:-latest}"

echo "Ni ŝargas la procezujojn por Cetoniujo el la deponejo ĉe Github (Ghcr), etikedo: '${label}'"

docker pull ghcr.io/revuloj/voko-cetonio/voko-cetonio:${label}
docker pull ghcr.io/revuloj/voko-grilo/voko-grilo:${label}
docker pull ghcr.io/revuloj/voko-akrido/voko-akrido:${label}
docker pull ghcr.io/revuloj/voko-cikado/voko-cikado:${label}

# alinomu por loka uzo
docker tag ghcr.io/revuloj/voko-cetonio/voko-cetonio:${label} voko-cetonio
docker tag ghcr.io/revuloj/voko-grilo/voko-grilo:{label} voko-grilo
docker tag ghcr.io/revuloj/voko-akrido/voko-akrido:${label} voko-akrido
docker tag ghcr.io/revuloj/voko-cikado/voko-cikado:${label} voko-cikado

