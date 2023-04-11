#! /bin/bash

set -e

NAME=pipeline-FIXME
if [ "${TARGET_CONDA_ENV}" ] ; then
    NAME="${TARGET_CONDA_ENV}"
fi

CONDA_PREFIX=$(dirname $(dirname $(type -p conda)))
. "${CONDA_PREFIX}/etc/profile.d/conda.sh"

PACKAGES=
#PACKAGES+=" pip"

PACKAGES+=" FIXME"

if [ "$(type -p mamba)" ] ; then
    _conda="mamba --no-banner"
else
    _conda=conda
fi

function __ {
    echo + "$@"
    eval "$@"
}

if [ "$1" = -f ] ; then
    __ conda env remove -y --name ${NAME}
fi

_install=update
if [ ! -d ${CONDA_PREFIX}/envs/${NAME} ] ; then
    __ conda create -y --name ${NAME}
    _install=install
fi
__ conda activate ${NAME}

__ $_conda $_install -y ${PACKAGES}

# __ pip $_install FIXME
