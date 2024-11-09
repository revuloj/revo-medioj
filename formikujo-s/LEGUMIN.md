# Formikujo

- Formiko (voko-formiko)
- Afido (voko-afido)

[superrigardo](../doc/formikujo.svg)

Formikujo estas la redaktoservo, kiu povas akcepti redaktojn kaj rekalkuli la HTML-dosierojn de Reta Vortaro.
Normale la redaktoservo funkcias kiel Gihub-ago, difinita per skripto en la projekto `revo-fontoj`. 
Tiu ĉi medio estas uzata por:

- elprovi loke novajn eldonojn, analizi erarojn ktp.
- akcepti redaktojn per retpoŝto, kio ne bone funkcius en efemera medio kiel Github

Formikujo konsistas el pluraj procezujoj (voko-formiko, voko-afido, evtl-e voko-tomocero). La kompono estas difinita en la dosiero `docker-compose.yml`.

## Instali:

Necesas instali unue lokan poŝtservon por ricevi kaj sendi retpoŝtojn. Vi povas
uzi la instrukciojn [instali poŝtservon](../doc/instali_poŝtservon.md) por instali poŝtservon 
`postfix` kune kun akceptilo `fetchmail`. Principe vi povas uzi ankaŭ nur `fetchmail` kaj
sendi konfirmojn rekte tra fora poŝtservilo, sed tiam ĉe (ret)eraroj la forsendo tute fiaskas,
dum loka poŝtservo povas konservi kaj reprovi sendadon.

Nun instalu la bezonaĵojn por la redaktoservo:

1. Akiru la procezujojn voko-afido kaj voko-formiko per 
  ```
    cd revo-medioj/formikujo-s
    bin/fs-akir
  ```
2. Kreu SSH-ŝlosilparon por la komuniko inter Formiko kaj Afido per:
  ```
    bash bin/voko-formiko-sekretoj
  ```
3. Kreu SSH-ŝlosilparon por komuniko inter Afido kaj Github
  ```
    ssh-keygen -t rsa
  ```
  Metu la publikan parton ĉe [Github](https://github.com/revuloj/revo-fonto/settings/keys)
4. Difinu la medivariablojn SMTP_SERVER, SMTP_USER, SMTP_PASSWORD por aliro al via (loka) retpoŝta servo, 
  t.e. por forsendo de konfirmaj mesaĝoj al redaktantoj. (Se aliro al via komputilo estas sekura vi povas daŭre meti ilin
  ekzemple en ~/.bashrc aŭ skribi ilin rekte en bin/voko-afido-sekretoj.)  
5. Instalu la sekretojn por Afido per
  ```
    bash bin/voko-afido-sekretoj 
  ```

... kio ankoraŭ mankas?

10. Lanĉu Formikujon per
  ```
    ../bin/kreu_reton.sh
    bin/fs-start
  ```

Post sukcesa lanĉo de Formikujo vi povas lanĉi individuajn celojn por la programo `Apache Ant` per la skripto `formiko`. Ĝi ankaŭ enhavas helpinformojn pri kiuj celoj ekzistas. Voku do ekzemple:

```
  # ĝeneralaj informoj kaj eblaj prefiksoj
  bin/fs-formiko formiko -h

  # celoj de la prefikso inx- por krei diversajn indeksojn
  bin/fs-formiko formiko inx-?

  # por krei ĉiujn indeks-dosierojn (daŭras!)
  bin/fs-formiko formiko inx-tuto
```