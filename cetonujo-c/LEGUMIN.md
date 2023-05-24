Tio estas aranĝo por ruli la redaktilon Cetonio inkluzive de kontroliloj kaj serĉilo
surbaze de nura skripto docker-compose. 

(Tiu funkcias ankaŭ en virtualaj serviloj, kiuj ne subtenas
uzi avancajn ecojn de virtualaj retoj kiel docker swarm aŭ k8s.
Aranĝo por docker swarm troviĝas en apuda cetonio-s)


## Uzo kun docker-compose

Por helpi la administradon de Cetoniujo en docker-compose vi povas utiligi la skriptojn `bin/cc-*`.

Preparoj:

    - agordu dosieron `../../etc/.env` surbaze de `etc/.env.tmpl`
    - Ni uzas la difinitajn servojn en `docker-compose.yml`
    - instalu la bezonatajn procezujojn per `bin/cc-akir.sh`
    - aktualigu la datumbazojn per `bin/cc-db.sh redaktantoj` kaj `bin/cc-db.sh db-upd`

Lanĉo:

    - voku `bin/cc-start.sh`
    - post aktualigo de procezujoj vi povas revoki `bin/cc-start.sh`
    - por fini la servon vi povas voki `bin/cc-stop.sh`
    - por aktualigi la datumbazon vi povas uzi regule `bin/cc-db.sh db-upd` (ne necesas relanĉi la servon post tio)

