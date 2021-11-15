# Kiel instali HTTPS-servon kun Apache kaj atestilo de Let's Encrypt

## Antaŭkondiĉoj

- (virtuala) servilo luita
- retnomo registrita por tiu servilo (ekz-e mia.servo.eo)
- ssh agordita por aliri la servilon

Ni priskribas la procedon por Ubunto, sed simile devus funkcii en alia Linuks-distribuo

## Agordi fajromuron

Vi konduku la instaladon kiel uzanto `root` aŭ prefiksu ĉiun komandon per `sudo`. Kiel redaktilo ni
uzas `vi` - se vi ne ŝatas ĝin vi povas uzi alian kiel 
`nano` aŭ `pico`.

```
# instalu ufw (Ubunto Fajromuro)
apt install ufw

# rigardu la situacion
ufw status
ufw app list

# malpermesu ĉion, kio ne estas permesata
ufw default deny

# permesu SSH kaj HTTP/HTTPS
ufw allow OpenSSH
ufw allow "Apache Full"

# kontrolu kaj aktivigu la fajromuron
ufw status verbose
ufw enable
```

## Instalu Apache + Certbot kaj akiru atestilon

```
apt install apache2

# vd: https://certbot.eff.org/instructions?ws=apache&os=ubuntu-18

apt install snapd fuse
snap install core
snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
certbot --apache

# kontrolu ĉu refreŝigo funkcios estonte
certbot renew --dry-run
cat /etc/cron.d/certbot
```

## Agordo de Apache

Ni supozas, ke nia provizenda servo estas redaktilo funkciahta loke en la pordo 8080, do ĉe `http://localhost:8080/redaktilo`.
Vi povas kontroli per `curl -L http://localhost:8080` aŭ simile.

Tiun servon ni protektos nun malantaŭ Apache-servilo, kiu funkcios kiel ĉifranta proksimaĵo.

```
rm /var/www/html/index.html

vi /etc/apache2/apache2.conf

  # forkomentu la agordon pri la dosierujo 
  # /usr/share (kelkaj linioj en tiu dosiero)

# altigu la sekurecon
vi /etc/apache2/conf-enabled/security.conf

  ServerTokens Prod

# agordu la plusendadon
a2enmod proxy
a2enmod proxy_http
  
vi /etc/apache2/mods-enabled/proxy.conf

  ProxyPass "/redaktilo" "http://localhost:8080/redaktilo"
  ProxyPassReverse "/redaktilo" "http://localhost:8080/redaktilo"

vi /etc/apache2/mods-enabled/alias.conf

  Redirect "/" "/redaktilo/"

# relanĉu Apache
service apache2 restart
```

Provu nun per retumilo, ĉu la servo estas uzebla ĉe
`http://mia.servo.eo`. Ĝi devus aŭtomate plusendi al `https` 
kaj montri la enirpaĝon de nia loka servo (kondiĉe, ke ĝi jam estas funkciigita!)
