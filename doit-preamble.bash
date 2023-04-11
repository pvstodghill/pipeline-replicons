#! /bin/bash

# In order to help test portability, I eliminate all of my
# personalizations from the PATH, etc.
if [ "$PVSE" ] ; then
    HOWTO_CONDA_CMD="${HOWTO_CONDA_CMD:-$(type -p mamba)}"
    HOWTO_CONDA_CMD="${HOWTO_CONDA_CMD:-$(type -p conda)}"
    if [ "$HOWTO_CONDA_CMD" ] ; then
	export HOWTO_CONDA_CMD
    fi
    export PATH=/usr/local/bin:/usr/bin:/bin
    export PERL5LIB=
    export PERL_LOCAL_LIB_ROOT=
    export PERL_MB_OPT=
    export PERL_MM_OPT=
    export PYTHONPATH=
fi

# ------------------------------------------------------------------------

# yuck. ugly.

if [ -e /programs/docker/bin/docker1 ] ; then
    export HOWTO_DOCKER_CMD=/programs/docker/bin/docker1
    THREADS=32
else
    THREADS=$(nproc --all)
fi

if [ -e /programs/parallel/bin/parallel ] ; then
    PARALLEL_CMD=/programs/parallel/bin/parallel
fi

# ------------------------------------------------------------------------

# These vars are used in parameters to stubs/*, so they cannot be
# `realpath`'ed.
PIPELINE=$(dirname ${BASH_SOURCE[0]})
# v-- can be specified externally
DATA=${DATA:-data}

# ------------------------------------------------------------------------

. config.bash

# ------------------------------------------------------------------------

export HOWTO_MOUNT_DIR=$(realpath $(${PIPELINE}/howto/find-closest-ancester-dir . ${DATA} ${PIPELINE}))
export HOWTO_TMPDIR=$(realpath ${DATA})/tmp

if [ "$PACKAGES_FROM" = conda ] ; then
    if [ -z "$CONDA_EXE" ] ; then
	CONDA_EXE=$(type -p conda)
    fi
fi

case X"$PACKAGES_FROM"X in
    XcondaX)
	CONDA_PREFIX=$(dirname $(dirname $CONDA_EXE))
	. "${CONDA_PREFIX}/etc/profile.d/conda.sh"
	conda activate $CONDA_ENV || exit 1
	;;
    XX|XhowtoX|XstubsX)
	export PATH=$(realpath ${PIPELINE})/stubs:"$PATH"
	;;
    XnativeX)
	: nothing
	;;
    XX)
	echo 1>&2 "\$PACKAGES_FROM is not set"
	exit 1
	;;
    X*X)
	echo 1>&2 "\$PACKAGES_FROM is recognized: $PACKAGES_FROM"
	exit 1
	;;
    *)
	echo 1>&2 "Cannot happen"
	exit 1
esac

# ------------------------------------------------------------------------

if [ -z "$PARALLEL_CMD" ] ; then
    PARALLEL_CMD="$(type -p parallel)"
fi

# Usage: generate_commands_to_stdin | run_commands_from_stdin
function run_commands_from_stdin {
    if [ "$PARALLEL_CMD" -a "$THREADS" -gt 1 ] ; then
	eval $PARALLEL_CMD -j ${THREADS} -kv
    else
	bash -x
    fi
}

# ------------------------------------------------------------------------

set -e
set -o pipefail

export LC_ALL=C

# ------------------------------------------------------------------------

INPUTS=${DATA}/0_inputs
SPLIT=${DATA}/genomes
