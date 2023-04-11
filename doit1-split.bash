#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------

rm -rf ${SPLIT}
mkdir -p ${SPLIT}

# ------------------------------------------------------------------------
# Splitting .fna files
# ------------------------------------------------------------------------

echo 1>&2 '# Splitting .fna files...'

for FNA in ${INPUTS}/*.fna ; do
    NAME=$(basename $FNA .fna)
    cat ${INPUTS}/${NAME}.fna | ${PIPELINE}/scripts/split-fasta -v -x .fna -d ${SPLIT}
done

echo 1>&2 '# Splitting .gff files...'

for GFF in ${INPUTS}/*.gff ; do
    NAME=$(basename $GFF .gff)
    cat ${INPUTS}/${NAME}.gff | ${PIPELINE}/scripts/split-gff -d ${SPLIT}
done

echo 1>&2 '# Splitting .faa files...'

for FAA in ${INPUTS}/*.faa ; do
    NAME=$(basename $FAA .faa)
    ${PIPELINE}/scripts/split-faa -d ${SPLIT} ${INPUTS}/${NAME}.faa ${INPUTS}/${NAME}.gff
done

echo 1>&2 '# Renaming for readability...'

PUNCT='~'

grep '>' ${INPUTS}/*.fna \
    | sed -E \
	  -e 's|'${INPUTS}'/||' \
	  -e 's/(.*).fna:>gnl\|Prokka\|(.*)_([0-9]+)$/\1\t\2\t\3/' \
    | tr '\t' '\a' \
    | (
    while IFS=$'\a' read COLLECTION_NAME PROKKA_NAME I ; do
	mv ${SPLIT}/${PROKKA_NAME}_${I}.fna ${SPLIT}/${COLLECTION_NAME}${PUNCT}${I}.fna
	if [ -e ${SPLIT}/${PROKKA_NAME}_${I}.gff ] ; then
	    mv ${SPLIT}/${PROKKA_NAME}_${I}.gff ${SPLIT}/${COLLECTION_NAME}${PUNCT}${I}.gff
	fi
	if [ -e ${SPLIT}/${PROKKA_NAME}_${I}.faa ] ; then
	    mv ${SPLIT}/${PROKKA_NAME}_${I}.faa ${SPLIT}/${COLLECTION_NAME}${PUNCT}${I}.faa
	fi
    done

)

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 '# Done.'

