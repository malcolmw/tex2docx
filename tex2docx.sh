#!/usr/bin/env bash

for ACTION in accept reject; do
    DIR=/Users/malcolmwhite/Desktop/White_et_al_2019a_${ACTION};
    rm -frv $DIR;
    mkdir $DIR;
    cd $DIR;
    rsync -avP /Users/malcolmwhite/Desktop/White_et_al_2019a_rev1/ .;
    rm -frv *.tex

    for FILE in $(ls /Users/malcolmwhite/Desktop/White_et_al_2019a_fragile/*.tex); do
        BASENAME=$(basename $FILE);
        python2.7 ~/src/tutorials/trackchanges-0.7.0/PythonPackage/${ACTION}changes.py \
            --infile=$FILE \
            --outfile=tmp_a.$BASENAME \
            -c;
        sed 's/<e.g.,>//g' tmp_a.$BASENAME | tee -a tmp_b.$BASENAME;
        sed 's/citeA/cite/g' tmp_b.$BASENAME | tee -a $BASENAME;
    done

    rm -frv tmp_a.* tmp_b.*;

    pandoc -f latex -t docx main.tex -o main.docx --bibliography=references.bib --default-image-extension=.png --reference-links
done
