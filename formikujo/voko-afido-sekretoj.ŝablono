#!/bin/bash

keyfile_pub=${HOME}/.ssh/formiko.pub
#keyfile_github=${HOME}/.ssh/id_rsa_revo
keyfile_github=${HOME}/.ssh/id_rsa

if [ ! -e ${keyfile_pub} ]; then
    echo "Mankas ${keyfile_pub}. Vi devas unue lanĉi voko-formiko-sekretojn por ricevi ŝlosilparon!"
    exit 1
fi

if [ ! -e ${keyfile_github} ]; then
    echo "Mankas ${keyfile_github}. Vi bezonas ŝlosilon por povi puŝi ŝangojn al github.com - demandu Revo-administranton!"
    exit 1
fi

echo "# forigante malnovajn sekretojn voko-afido.* ..."
secrets=$(docker secret ls --filter name=voko-afido. -q)
docker secret rm ${secrets}

echo
echo "# metante novajn sekretojn..."
cat ${keyfile_pub} | docker secret create voko-afido.ssh_key.pub -
cat ${keyfile_github} | docker secret create voko-afido.github_key -
#echo "smtp.provizanto.org" | docker secret create voko-afido.smtp_server -
#echo "redaktoservo@provizanto.org" | docker secret create voko-afido.smtp_user -
#echo "M14P$svort0" | docker secret create voko-afido.smtp_password -
echo "tomocero" | docker secret create voko-afido.smtp_server -
echo "tomocero@tomocero" | docker secret create voko-afido.smtp_user -
echo "sekreta" | docker secret create voko-afido.smtp_password -

docker secret ls --filter name=voko-afido. 

# Uzante la procesumon voko-tomocero por forsendo de retpoŝtoj vi anstataŭe donu por smtp
# la sekvan agordon. La avantaĝo estas, ke tomocero transsendas la retpoŝtojn en serioj
# kaj tiel ne por ĉiu unuopa retpoŝto okazas rekonekto, kion kelkaj provizantoj
# malhelpas per kelkminuta deviga paŭzo.
#   echo "voko-tomocero" | docker secret create voko-afido.smtp_server -
#   echo "" | docker secret create voko-afido.smtp_user -
#   echo "" | docker secret create voko-afido.smtp_password -
