#!/bin/bash
  
rm -rf test-repo  
mkdir test-repo
cd test-repo
git init

mkdir bld 
mkdir revo
mkdir cfg

echo "<xml>" > bld/test.svg
echo "<xml>" > bld/test1.svg

cat << EOF1 > revo/artefakt.xml
<?xml version="1.0"?>
<!DOCTYPE vortaro SYSTEM "../dtd/vokoxml.dtd">
<vortaro>
<art mrk="\$Id\$">
<kap>
  <rad>artefakt</rad>/o <fnt><bib>SPIV</bib></fnt>
</kap>
<drv mrk="artefakt.0o">
  <kap><tld/>o</kap>
  <snc mrk="artefakt.0o.ARKE">
    <uzo tip="fak">ARKE</uzo>
    <dif>
      <ref tip="dif" cel="art.0efaritajxo.KOMUNE">Artefarita&jcirc;o</ref>,
      objekto prilaborita por iu celo a&ubreve; uzo
      kontraste al a&jcirc;o rezultanta de natura procezo:
      <ekz>
        ritaj <tld/>oj el tombo 268 de la tombejo &Gcirc;arkutan 4B
        <fnt>
          <aut>V. I. Ionesov</aut>
          <vrk><url
          ref="http://www.eventoj.hu/steb/arkeologio/baktrio/baktrio2.htm">
          Kulturo kaj socio de Norda Baktrio</url></vrk>
          <lok>Scienca Revuo, 1992:1 (43), p. 3a-8a</lok>
        </fnt>.
      </ekz>
    </dif>
  </snc>
  <trd lng="fr">artefact</trd>
</drv>
</art>
<!--
\$Log\$
-->
</vortaro>
EOF1

cat << EOE > cfg/enhavo.xml
<?xml version="1.0"?>
<!DOCTYPE enhavo SYSTEM "../dtd/vokoenh.dtd">
<enhavo nomo="Reta Vortaro" nometo="ReVo" piktogramo="revo.ico">
  <bonveno>
    <sercho tipo="revo" ref="http://reta-vortaro.de/revo/cfg/sercxo2.xml" titolo="Revoser&ccirc;o"/>
    <sercho tipo="google" ref="http://reta-vortaro.de/revo/cfg/sercxo.xml" titolo="Revoser&ccirc;o per Google"/>
    <resumo ref="http://www.reta-vortaro.de/sxangxoj.rdf" titolo="resumo de lastaj &scirc;an&gcirc;oj (por RSS-legilo)"/>
    <alineo>
      Jen Revo &#8213; la &gcirc;enerala esperanta vortaro en la reto.
    </alineo>
  </bonveno>
  <pagho titolo="ktp." dosiero="_ktp.html">
    <sekcio titolo="por uzantoj">
      <ero ref="../dok/mallongigoj.html" titolo="Vortaraj mallongigoj"/>      
      <ero ref="../dok/bibliogr.html" titolo="Bibliografio la&ubreve; mallongigoj" 
	style="margin-top: 0.4em; margin-bottom: 0"/>
      <STAT titolo="Statistiko" style="margin-top: 0.4em; margin-bottom: 0"/>
      <ero ref="../dok/copying.txt" titolo="Permeso de uzado" kadro="_new"/>
    </sekcio>
    <sekcio titolo="por redaktantoj">
       <ero ref="novaj.html" titolo="Novaj artikoloj"/>
       <ero ref="shanghoj.html" titolo="&Scirc;an&gcirc;itaj artikoloj"/>
       <ero ref="eraroj.html" titolo="Strukturaj eraroj"/>
    </sekcio>
  </pagho>
</enhavo>
EOE

cat << EOB > cfg/bibliogr.xml
<!DOCTYPE bibliografio [
<!ELEMENT bibliografio (vrk)*>
<!ELEMENT vrk (url?,aut*,trd?,tit?,ald?,eld*)>
<!ATTLIST vrk mll ID #REQUIRED
              tip (vortaro|leksikono|terminaro|beletro|rimajho|parolo|revuo) #IMPLIED> 
<!ELEMENT url (#PCDATA)>
<!ELEMENT aut (#PCDATA|a|n)*>
<!ELEMENT n   (#PCDATA)>
<!ELEMENT a   (#PCDATA)>
<!ELEMENT trd (#PCDATA|a|n)*>
<!ELEMENT tit (#PCDATA)>
<!ELEMENT isbn (#PCDATA)>
<!ELEMENT ald (#PCDATA)>
<!ELEMENT eld (nom?,lok?,dat?,nro?,isbn?)>
<!ELEMENT nom (#PCDATA)>
<!ELEMENT lok (#PCDATA)>
<!ELEMENT dat (#PCDATA)>
<!ELEMENT nro (#PCDATA)>
<!ENTITY % signoj SYSTEM "../dtd/vokosgn.dtd">
%signoj;
]>
<bibliografio>  
  <vrk mll="9OA" tip="vortaro">
    <url>http://www.akademio-de-esperanto.org/decidoj/9oa.html</url>
    <aut>Akademio de Esperanto</aut>
    <tit>Na&ubreve;a Oficiala Aldono al la Universala Vortaro</tit>
  </vrk>
</bibliografio>
EOB

git config --global user.email "neniu@example.com"
git config --global user.name "Ja Neniu"

git add bld revo cfg
git commit -m"v1"
git tag "v1"

sed -i "s|\.\./dok/mallongigoj.html|http://retavortaro.de/revo/dok/mallongigoj.html|" cfg/enhavo.xml

cat << EOF2 > revo/modif.xml
<?xml version="1.0"?>
<!DOCTYPE vortaro SYSTEM "../dtd/vokoxml.dtd">

<vortaro>
<art mrk="\$Id\$">
<kap>
  <ofc>3</ofc>
  <rad>modif</rad>/i
</kap>
<drv mrk="modif.0i">
  <kap><tld/>i</kap>
  <gra><vspec>tr</vspec></gra>
  <snc>
    <dif>
      Parte &scirc;an&gcirc;i ion ne tu&scirc;ante la esencon:
      <ekz>
        <tld/>i la formon de;
      </ekz>
      <ekz>
        <tld/>i projekton, le&gcirc;on, aran&gcirc;on.
      </ekz>
    </dif>
  </snc>
</drv>
</art>
<!--
\$Log\$
-->
</vortaro>
EOF2

git add revo cfg
git commit -m"v2"
git tag "v2"

rm bld/test.svg
git add bld
git commit -m"v3"
git tag "v3"


rm revo/artefakt.xml
git add revo
git commit -m"v4"
git tag "v4"