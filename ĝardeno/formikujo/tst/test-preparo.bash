#!/bin/bash

### Ĉu Afido kaj Tomocero estas aktivaj? Ni bezonas iliajn n-rojn...
afido_id=$(docker ps --filter name=formikujo_afido -q) && echo "Afido: ${afido_id}"
tomocero_id=$(docker ps --filter name=formikujo_tomocero -q) && echo "Tomocero: ${tomocero_id}"
