#!/bin/bash

### Ĉu Afido ktp. estas aktivaj? Ni bezonas iliajn n-rojn...
afido_id=$(docker ps --filter name=formikujo_afido -q) && echo "Afido: ${afido_id}"
tomocero_id=$(docker ps --filter name=formikujo_tomocero -q) && echo "Tomocero: ${tomocero_id}"
formiko_id=$(docker ps --filter name=formikujo_formiko -q) && echo "Formiko: ${formiko_id}"

# Plibonigu: kiel ni povas montri tion en "bats"?
if [ "${afido_id}" = "" ]; then echo "Afido ne aktiva!" 1>&2; exit 1; fi
if [ "${tomocero_id}" = "" ]; then echo "Tomocero ne aktiva!" 1>&2; exit 1; fi
if [ "${formiko_id}" = "" ]; then echo "Formiko ne aktiva!" 1>&2; exit 1; fi


