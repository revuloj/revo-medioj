Tiu priskribo estas por Revo-administrantoj!

Por akcepti redaktojn per submetoj tra la datumbazo aŭ gists.github.com ne necesas aparta servilo. Tion faras Github-ago en la arĥivo revo-fonto per la Docker-procezujo voko-afido.

Tamen plu estas akceptataj redaktoj ankaŭ retpoŝte laŭ la malnova vojo funkcianta jam ekde 1999. Ĉar estas iom tikla afero trakti retpoŝtojn en efemera instanco de procezujo - aparte estas la risko ke perdiĝos retpoŝtoj okaze de neatendita eraro - estas konsilinde tion fari per konstanta servilo (virtuala maŝino sufiĉas), kiu konservas ĉion dum akcepto kaj trakto.

La malsupraj priskriboj estas por la Linuks-distribuo Ubunto 18.04, sed kun ioma adapto estus aplikeblaj ankaŭ por aliaj linuksaj aŭ uniksaj sistemoj.

Komandoj post `$` estu faritaj kiel administranto (root) aŭ per la komando `sudo`. Komandoj post `revo>` estu farataj kiel uzanto `revo`. Linioj post komando `vim` kun spaceto antaŭe donas la enhavon de la redaktata dosiero - ĝi kutime aperu sen komenca spaceto en tiu dosiero. La spaceto servas nur por distingi ĝin de la komandoj.

# Ekipi la poŝtoficejon

Ni antaŭ ĉio bezonas la eblecon akcepti poŝton (per `fetchamil`), meti ĝin en la lokan poŝtfakon kaj forsendi respondojn (per `postfix`). Instalado de poŝtoservo estas iom malsimpla afero, sed jen ni kondukas tra la unuopaj paŝoj.

## Instali la bezonatajn programojn

```
$ apt install fetchmail postfix mailutils sasl2-bin libsasl2-2 libsasl2-modules cyrus-common
```

Mi ne certas ĉu vi vere bezonas cyrus-common, sed por esti certa mi mencias ĝin.

## Instali atestilojn

Por identiĝi kaj ĉifri la trafikon la poŝtserviloj uzas TLS-atestilojn, kiu pruvas sian validecon per ĉeno. Eble la ĉeno funkcias senpere, sed kutime oni devas instali la atestilojn. Ni supozas, ke por akcepti kaj sendi vi uzos diversajn provizantojn. Tiam vi bezonas atestilojn de ambaŭ. Malsupre vi devos meti la ĝustajn nomojn anstataŭ la majusklaj nomoj. Eble ankaŭ la prefikso estas alia ĉe via provizanto ekz. post.example.org aŭ simile...

```
$ cd /etc/ssl/certs
$ openssl s_client -connect pop3.RICEVSERVILO.COM:465 -showcerts > RICEVSERVILO-pop3.pem
$ openssl s_client -connect smtp.SENDSERVILO.COM:465 -showcerts > SENDSERVILO-smtp.pem
$ c_rehash .
```
## Agordi `postfix`

Ni nun devas adapti la ĉefan agordon de `postfix` por ke ĝi sciu kiel plusendi retpoŝtojn. Kiel redaktilo vi povas uzi `vim` (`vi`) aŭ `pico, `nano` - depende de viaj preferoj.

```
vim /etc/postfix/main.cf
	myhostname = MIA.SERVILO.NET
	relayhost = smtp.SENDSERVILO.COM:465

	smtp_sasl_auth_enable = yes  
	smtp_sasl_password_maps = hash:/etc/postfix/relay_user
	smtp_sasl_security_options = noanonymous
	smtp_sasl_tls_security_options = noanonymous   

	# por pordo :465
  	smtp_tls_wrappermode = yes
  	smtp_tls_security_level = encrypt

	# smtp_tls_CAfile = /etc/ssl/certs/SENDSERVILO-smtp.pem
	#smtpd_sasl_authenticated_header = yes
	#debug_peer_level = 3
	#debug_peer_list = smtp.SENDSERVILO.COM
	smtp_tls_enforce_peername = no
	#smtpd_sasl_type = dovecot
	#smtpd_sasl_path = private/auth 
	#smtpd_sasl_type = cyrus 
	#cyrus_sasl_config_path = /etc/postfix/sasl/ 
	#smtp_sasl_mechanism_filter = plain, login
	sender_canonical_maps = hash:/etc/postfix/sender_canonical
```

La linioj kun komenca # estas komentoj kaj opcioj, kiujn mi ne devis adapti, sed eble vi bezonos ilin se vi renkontas erarojn kaj devas ludi kun ili.

La uzanton kaj pasvorton de via send-poŝtfako vi metu en la dosieron `relay_user`:

```
$ cd /etc/postfix
$ echo smtp.SENDSERVILO.COM UZANTO:PASVORTO > relay_user
$ chmod 600 relay_user
$ postmap relay_user

```

Kiam ni forsendas retpoŝton ni volas anstataŭigi iun strangan lokan uzanton per la oficiala retadreso `revo@retavortaro.de`. Tion ni faros tiel:

```
$ echo "root revo@retavortaro.de" > sender_canonical
$ echo "revo revo@retavortaro.de" >> sender_canonical
$ chmod 600 sender_canonical
$ postmap /etc/postfix/sender_canonical
```

Post relanĉo de la poŝtservo administranto nun jam povus forsendi releterojn, sed ni volos permesi al posta uzanto `revo` kiun ni uzos kun `fetchmail` la forsendadon. Por simpligi ni simple permesos al ĉiuj lokaj uzantoj forsendadon de retleteroj. Se vi volas limigi tion al nur certaj uzantoj, vi bv. studi la dokumentaron de `postfix` kiel atingi tion :-)

La agordo jam estas preparita en `master.cf`, sed ni devos forkomenti kelkajn liniojn, t.e. vi trovu ilin kaj forigu la antaŭmetitan `#`.

```
$ vim /etc/postfix/master.cf
 submission inet n       -       y       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_relay_restrictions=permit_mynetworks,reject
  -o milter_macro_daemon_name=ORIGINATING
```

Se loke vi volas saluti per SASL, vi bezonos pliaj agordojn, kiun mi ne klarigos tie ĉi. Espereble vi ne bezonos ilin.

Nun ni relanĉos la poŝtservilon:

```
$ service postfix restart
$ systemctl daemon-reload
```

## Krei uzanton `revo` kaj sekurigi aliron al la servilo

Ni unue kreas uzanton `revo`:

```
$ mkdir /home/revo
$ useradd -d /home/revo -s /bin/bash -c"Reta Vortaro" revo
$ usermod -a -G mail revo
$ passwd revo
```

Krome ni bezonas permesi al ĝi poste forsendi la poŝtsakon per `sendmail -q`:

```
$ vim /etc/sudoers
  Cmnd_Alias SMQ = /usr/sbin/sendmail -q
  revo ALL= NOPASSWD: SMQ
```

Por bona sekureco, ni rekomendas, ke vi instalu SSH-atestilon por la uzanto `revo` (bv. trovu instrukciojn ie en la reto) kaj se tio funkcias malŝaltu alireblecon al via servilo per pasvorto kaj per konto de administranto.

Nepre testu la alireblecon al la servilo per uzanto `revo` kaj la atestilo (do saluto sen pasvorto) antaŭ la sekva adapto de `sshd`, ĉar aliokaze se vi estas malfeliĉa vi poste ne plu povos ensaluti vian servilon per `ssh` kaj bezonos rekrei la administran konton kun nova pasvorto (aŭ reinstali ĉion...).

```
$ vim /etc/ssh/sshd_config
  ChallengeResponseAuthentication no
  PasswordAuthentication no
  PermitRootLogin no
  UsePAM no

$ systemctl reload sshd
```

Krome (kun sama risko de elŝlosado) ni rekomendas instali kaj agordi fajromuron `ufw` por permesi aliri la servilon tra la reto ekskluzive per `ssh`:

```
$ apt install ufw
$ ufw allow ssh
$ ufw enable
$ ufw logging low
$ ufw status verbose
```

## Agordi `fetchmail`

Ni nun povas meti agordon por `fetchmail`en la dosierujon de `revo`:

```
$ su revo
revo> cd ~
revo> mkdir etc
revo> vim etc/fetchmailrc
  poll pop3.RICEVOSERVILO.COM proto pop3 user "UZANTO" password "PASVORTO" sslproto TLS1+ sslcertck sslcertpath /etc/ssl/cert

revo> chmod 400 etc/fetchmailrc
revo> vim .bashrc
 # FETCHMAIL-agordo
 export FETCHMAILHOME=$HOME/etc
revo> source .bashrc
```
Se ankoraŭ mankas la dosiero `.profile`ni devos krei ĝin ankaŭ, por ke ĝi apliku `.bashrc` ĉe lanĉo de terminalo.

```
vim ~/.profile
  if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
  fi
  # bloku interterminalan paroladon...
  mesg n || true
```

Bone, nun estus tempo por elprovi la poŝtoficejon, t.e. sendi retpoŝton al la riceva fako, preni ĝin per `fetchmail -k` (sen la `-k` ĝi tuj forigas la legitajn leterojn). Se `fetchmail` ne kapablas meti la legitan leteron en la lokan poŝtfakon verŝajne io mankas en la agordo de `postfix`. Krome provu sendi retleteron eksteren, ekz. per la komandlinia poŝtilo `mail`.

Ni ne detalas tion, vi facile trovos helpon en la reto...



# Instali la redaktoservon

Unue ni instalu kelkajn pliajn programojn kaj Perlo-modulojn:

```
$ apt install curl rxp git libjson-perl libtext-csv-perl liblog-dispatch-perl libmime-tools-perl
```

Ni nun povas instali la redaktoservon. Ni bezonas alkopii la fontojn kaj ni bezonas certan dosierujo-strukturon, vi povas lanĉi la skripton 
[`bin/setup_revo_loke.sh`](https://github.com/revuloj/voko-afido/blob/master/bin/setup_revo_loke.sh) por krei tiun.


```
revo> git clone https://github.com/revuloj/voko-afido.git
revo> git clone https://github.com/revuloj/voko-grundo.git
revo> bin/setup_revo_loke.sh
revo> ln -s ~/voko-grundo/dtd dict/dtd
revo> cd dict
revo> git clone git@github.com:revuloj/revo-fonto.git
```

Krome por aktualigi dosierojn en revo-fonto sen tajpi pasvorton vi bezonas aŭ ĵetonon (angle: *token*) kun la respektivaj permesoj aŭ SSH-ŝlosilon (angle: *Deploy key*). Ni uzas la duan eblecon. Vi kreas ordinaran SSH-ŝlosilparon laŭ unu el la multaj instrukcioj en la reto. La publikan parton vi devas instali por la deponejo `revo-fonto` 
[en Github per ties retpaĝoj](https://github.com/revuloj/revo-fonto/settings/keys) kaj la privatan vi deponas loke en dosierujo `~revo/.ssh/`. Poste ni agordas ĉion por `git`:

```
revo> cd ~
revo> vim .ssh/config
  Host github.com
  Hostname github.com
  IdentityFile /home/revo/.ssh/id_rsa_revo

revo> vim .gitconfig
  [user]
	name = revo
	email = revo@retavortaro.de
  [push]
	default = simple
```

La redaktoservo uzas liston de redaktantoj, kiun ĝi regule aktualigas el la datumbazo ĉe retavortaro.de tra CGI-skripto. Ĝi estas protektita per uzanto kaj pasvorto, kiun ni deponas en apartaj dosieroj sub `/run/secrets'. Bv. legi la skripton 
[bin/redaktoservo.sh](https://github.com/revuloj/voko-afido/blob/master/bin/redaktoservo.sh) por kompreni la detalojn.

Se ĉio estas boninstalita nun la redaktoservo jam devus funkcii vokante

```
revo> cd voko-afido
revo> bin/redaktoservo.sh
```

Se ne funkcias, necesos trairi ĉion detale por trovi la problemon. La skripto `bin/redaktoservo.sh` siavice vokas `curl`por ŝargi la redaktantojn, `fetchmail`por legi retpoŝton, `bin/processmail.pl` por trakti la retpoŝtajn redaktojn.

Fine vi povas aŭtomate lanĉi la redaktoservon, ekz-e ĉiun duan horon per `cron`:

```
revo> crontab -e
  SHELL=/bin/bash
  10 */2 * * * source ${HOME}/.bashrc; cd ${HOME}/voko-afido && bin/redaktoservo.sh >/dev/null 2>&1
```



