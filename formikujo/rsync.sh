#!/bin/bash

# Per rsync sinkronigu la rezultojn kun la servilo 
#
# Ni bezonas la servilon: REVO_TARGET
# kaj sekretan SSH-ŝlosilon: REVO_KEY
# Sed provizore ni agordas ilin loke per
# /etc/hosts (vera nomo de la servilo) kaj .ssh/config (uzanto, ŝlosilo)
REVO_TARGET=revo
#if [ -z "${REVO_TARGET}" ] || [ -z "${REVO_KEY}" ]; then
#    echo "Mankas unu el REVO_HOST aŭ REVO_KEY."
#    echo "Do ni ne kopias rezultajn dosierojn al la servilo."
#    exit 1
#fi

# transdonu la ŝlosilo al la agento
#eval `ssh-agent -s`
#ssh-add - <<< ${REVO_KEY}

#rsync -v -r -c -z --delete --stats ...
# -v = verbose, -r = subdosierujoj, -z = komprimite, -c = nur kies kontrolsumoj diferencas
# -n montru, kio okazus, sed ne efektive sinkronigu!

# rsync -v -r -c -z --stats revo/xml revo/art revo/inx revo/bld revo/hst revo/tez ${REVO_TARGET}:www/revo
#rsync -v -r -c -z --stats revo/xml revo/art revo/hst ${REVO_TARGET}:www/revo
rsync -v -r -c -z --stats revo/tez ${REVO_TARGET}:www/revo



