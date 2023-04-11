#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------
# Set up
# ------------------------------------------------------------------------

if [ -d ${DATA} ] ; then
    echo 1>&2 "# Removing ${DATA}. Hope that's what you wanted"
    rm -rf ${DATA}
fi

echo 1>&2 "# Initializing ${DATA}/..."
rm -rf ${DATA}/tmp
mkdir -p ${DATA}/tmp

# ------------------------------------------------------------------------
# Collecting input files
# ------------------------------------------------------------------------

echo 1>&2 "# Collecting input files..."
rm -rf ${INPUTS}
mkdir -p ${INPUTS}

cat ${COLLECTION_DIR}/data/metadata.tsv \
    | cut -f1,6 | tr '\t' '\a' \
    | (
    while IFS=$'\a' read NAME LEVEL ; do
	if [ "${NAME}" = Name ] ; then
	    if [ "${LEVEL}" != Level ] ; then
		echo 1>&2 "${LEVEL} != Level"
		exit 1
	    fi
	    continue
	fi
	if [ "${LEVEL}" != "Complete Genome" ] ; then
	    continue
	fi

	cp --archive ${COLLECTION_DIR}/data/genomes/"$NAME".fna ${INPUTS}/
	cp --archive ${COLLECTION_DIR}/data/genomes/"$NAME".faa ${INPUTS}/
	cp --archive ${COLLECTION_DIR}/data/genomes/"$NAME".gff ${INPUTS}/
    done
)

# ------------------------------------------------------------------------
# Removing outgroups
# ------------------------------------------------------------------------

if [ "${OUTGROUPS}" ] ; then
    echo 1>&2 "# Removing outgroups..."
    for NAME in ${OUTGROUPS} ; do
	rm -f ${INPUTS}/"$NAME".fna
	rm -f ${INPUTS}/"$NAME".faa
	rm -f ${INPUTS}/"$NAME".gff
    done
fi

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 '# Done.'

