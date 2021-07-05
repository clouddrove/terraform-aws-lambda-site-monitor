#!/bin/bash
export WRKDIR=$(pwd)
export LYR_PDS_DIR="layer"

# Building Python-pandas layer
cd ${WRKDIR}/${LYR_PDS_DIR}/
${WRKDIR}/${LYR_PDS_DIR}/build_layer.sh
zip -r ${WRKDIR}/${LYR_PDS_DIR}/nodejs.zip nodejs
