#!/bin/bash

# access_token ni uzas por aliri Github-API nome de reta-vortaro
access_token=$1

# tiun ŝlosilon ni uzas, por ke formiko povas voko afidon, verŝajne ni ne bezonas tion plu...
#keyfile_pub=${HOME}/.ssh/formiko.pub

# tiun ŝlosilon ni uzas por sendi ŝanĝojn al la Git-arĥivo (revo-fonto-testo...)
keyfile_github=${HOME}/.ssh/id_rsa_revo_test

# por testi sufiĉas arbitra sigelilo, ĉar ni ne havas redaktilon tie ĉi
sigelilo=$(cat /dev/urandom | tr -dc A-Z_a-z-0-9 | head -c${1:-16})

if [[ -z ${access_token} ]]; then
  echo "Vi devas doni ĵetonon de Github ('personal access token') kiel argumento por krei sekreton."
  exit 1
fi  

#if [ ! -e ${keyfile_pub} ]; then
#    echo "Mankas ${keyfile_pub}. Vi devas unue lanĉi voko-formiko-sekretojn por ricevi ŝlosilparon!"
#    exit 1
#fi

if [ ! -e ${keyfile_github} ]; then
    echo "Mankas ${keyfile_github}. Vi bezonas ŝlosilon por povi puŝi ŝangojn al github.com - demandu Revo-administranton!"
    exit 1
fi

secrets=$(docker secret ls --filter name=voko-afido. -q)
if [ ! -z "${secrets}" ]; then
    echo "# forigante malnovajn sekretojn voko-afido.* ..."
    docker secret rm ${secrets}
fi

echo
echo "# metante novajn sekretojn..."
echo ${access_token} | docker secret create voko-afido.access_token -
#cat ${keyfile_pub} | docker secret create voko-afido.ssh_key.pub -
cat ${keyfile_github} | docker secret create voko-afido.github_key -

echo ${sigelilo} | docker secret create voko-afido.sigelilo -

# transdonante retpoŝtojn rekte al ekstera retprovizanto.
#echo "smtp.provizanto.org" | docker secret create voko-afido.smtp_server -
#echo "redaktoservo@provizanto.org" | docker secret create voko-afido.smtp_user -
#echo "M14P4$svort0" | docker secret create voko-afido.smtp_password -

# uzante lokan procesumon voko-tomocero por transport retpoŝtojn...
#echo "tomocero" | docker secret create voko-afido.smtp_server -
#echo "tomocero@tomocero" | docker secret create voko-afido.smtp_user -
#echo "sekreta" | docker secret create voko-afido.smtp_password -

docker secret ls --filter name=voko-afido. 

# Uzante la procesumon voko-tomocero por forsendo de retpoŝtoj vi anstataŭe donu por smtp
# la sekvan agordon. La avantaĝo estas, ke tomocero transsendas la retpoŝtojn en serioj
# kaj tiel ne por ĉiu unuopa retpoŝto okazas rekonekto, kion kelkaj provizantoj
# malhelpas per kelkminuta deviga paŭzo.
#   echo "voko-tomocero" | docker secret create voko-afido.smtp_server -
#   echo "" | docker secret create voko-afido.smtp_user -
#   echo "" | docker secret create voko-afido.smtp_password -


