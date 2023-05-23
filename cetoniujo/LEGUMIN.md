Tio estas arango por ruli la redaktilon Cetonio inkluzive de kontroliloj kaj serĉilo
Estas pluraj eblecoj por fari tion

## Uzo kun docker swarm (konvena por loka uzo kaj testo)

Por helpi la administradon de Cetoniujo en docker swarm vi povas utiligi la skriptojn `bin/cs-*`.

Preparoj:

  - kreu instalaĵon de `docker swarm` laŭ la instrukcioj ĉe Docker en Interreto
  - kreu lokan reton per `../bin/kreu_reton.sh`
  - akiru ĉiujn procezujojn per `bin/cs-akir.sh`
    aŭ se vi mem volas kompili ilin: ŝargu la fontkodojn por voko-cetonio, voko-grilo, voko-akrido kaj voko-cikado el Github (`https://github.com/revuloj/`) 
    (la unuopaj projektoj havas skripton por kompilo `bin/eldono.sh kreo`, aŭ `docker build...`)
  - agordu la sekreto-dosieron laŭ la ŝablono en `voko-cetonio/etc/redaktilo.skr.tmpl`
  - transdonu la bezonatajn sekretojn al la procezujo per `bin/cs-sekret.sh /pado/al/redaktilo.skr`
  - difinu medio-variablon `REDAKTILO_URL`, ekz-e por loka uzo: `REDAKTILO_URL=http://0.0.0.0:8080/`
  - se vi volas uzi la redaktilon nur por vi, difinu ankaŭ medio-variablon `REDAKTANTO_RETPOSHTO` kun via retadreso (kiu estu registrita kiel redaktanto ĉe la redaktoservo de Revo)

Lanĉo:

  - lanĉu la aplikaĵon per `bin/cs-start.sh`. Tio uzas la difinojn en `docker-compose.yml`
  - unuafoje necesas krei la datumbazojn per `bin/cs-db.sh kreu-db`
  - la servo `cetonio-db` ĉiutage aktualigas la datumbazon, sed post kreo
    vi devos fari tion mem (aŭ fini kaj relanĉi la servon): `bin/cs-db.sh update-db`
  - navigu vian retumilon al la agordita adreso (`http://0.0.0.0:8080/`)
  - vi povas fini la aplikaĵon per `bin/cs-stop.sh`. La ceterajn komenadojn `docker stack...` vi povas uzi por analizi erarojn ks. Vi povas ankaŭ uzi `bin/cs-kmd.sh` kun unu el la komandoj.

## Uzo kun docker-compose (konvena por servilo)

Por helpi la administradon de Cetoniujo en docker swarm vi povas utiligi la skriptojn `bin/cc-*`.

Preparoj:

    - agordu dosieron `../../etc/.env` surbaze de `etc/.env.tmpl`
    - Ni uzas la difinitajn servojn en `docker-compose.srv.yml`
    - instalu la bezonatajn procezujojn per `bin/cc-akir.sh`
    - aktualigu la datumbazojn per `bin/cc-db.sh redaktantoj` kaj `bin/cc-db.sh db-upd`

Lanĉo:

    - voku `bin/cc-start.sh`
    - post aktualigo de procezujoj vi povas revoki `bin/cc-start.sh`
    - por fini la servon vi povas voki `bin/cc-stop.sh`
    - por aktualigi la datumbazon vi povas uzi regule `bin/cc-db.sh db-upd` (ne necesas relanĉi la servon post tio)

