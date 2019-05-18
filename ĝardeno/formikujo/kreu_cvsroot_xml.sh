#!/bin/bash

cvsroot_dir=$1;

if [ "${cvsroot_dir}" = "" ]; then
    echo
    echo "Atentu: Necesas doni kiel argumento dosierujon 'cvsroot' el kiu krei tie ĉi kopion:"
    echo "  kreu_cvsroot_xml.sh /pado/al/origina/cvsroot"
    exit 1
fi

echo "Kopiante ĉion el ${cvsroot_dir} al cvsroot..."
mkdir -p cvsroot
cp -auf ${cvsroot_dir}/CVSROOT cvsroot/
cp -auf ${cvsroot_dir}/revo cvsroot/

echo "Elverŝante aktualajn XML-dosierojn al xml/..."
mkdir -p xml
CVSROOT=$(pwd)/cvsroot cvs co -A -d xml revo 
