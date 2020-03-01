#!/bin/bash

echo "# forigante malnovajn sekretojn voko-tomocero.* ..."
secrets=$(docker secret ls --filter name=voko-tomocero. -q)
docker secret rm ${secrets}

echo
echo "# metante novajn sekretojn..."
# vi povas uzi myhostname=tomocero normale, ĉar akceptado de enventanta poŝto okazas
# per fetchmail, ne per postfix. Ne uzu myhostname=provizanto.org, ĉar tiam
# eliraj retpoŝtoj ne elsendiĝus 
echo "myhost.mydomain.org" | docker secret create voko-tomocero.myhostname -
echo "sekreta" | docker secret create voko-tomocero.saslpassword -

# tion vi bezonas por sendi kaj akcepti retpoŝton de via interreta poŝtprovizanto
# ordinate uzanto kaj pasvorto estas la samaj kaj por smtp kaj por pop3, sed tiel
# vi povus uzi diversajn poŝtfakojn por sendi kaj ricevi.
# Ni uzas relayaddress samtempe por identiĝi ĉe la smtp-servo kaj kiel sendinto por ĉiu
# eliranta poŝto. Se en iuj kazoj tio ne funkcias ĉe vi necesus enkonduki du diversajn sekretojn
# kaj adapti 00_setup_postfix.sh en voko-tomocero
echo "smtp.provizanto.org" | docker secret create voko-tomocero.relayhost -
echo "redaktoservo@provizanto.org" | docker secret create voko-tomocero.relayaddress -
echo "M14P$svort0" | docker secret create voko-tomocero.relaypassword -
echo "pop3.provizanto.org" | docker secret create voko-tomocero.pop3_server -
echo "redaktoservo@provizanto.org" | docker secret create voko-tomocero.pop3_user -
echo "M14P$svort0" | docker secret create voko-tomocero.pop3_password -

docker secret ls --filter name=voko-tomocero. 

