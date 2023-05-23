#!/bin/bash

echo "Ni ŝargas la procezujojn por Cetoniujo el la deponejo ĉe Github (Ghcr)"

docker pull ghcr.io/revuloj/voko-cetonio/voko-cetonio
docker pull ghcr.io/revuloj/voko-grilo/voko-grilo
docker pull ghcr.io/revuloj/voko-akrido/voko-akrido
docker pull ghcr.io/revuloj/voko-cikado/voko-cikado

# alinomu por loka uzo
docker tag ghcr.io/revuloj/voko-cetonio/voko-cetonio voko-cetonio
docker tag ghcr.io/revuloj/voko-grilo/voko-grilo voko-grilo
docker tag ghcr.io/revuloj/voko-akrido/voko-akrido voko-akrido
docker tag ghcr.io/revuloj/voko-cikado/voko-cikado voko-cikado