#!/bin/sh

if [ -z "${BASE}" ]; then
    export BASE="https://localhost"
fi

if [ -z "${MDX}" ]; then
    export MDX="http://localhost/mdx"
fi

if [ -z "${CDB}" ]; then
    export CDB="http://localhost/cdb"
fi

if [ -z "${DISCO}" ]; then
    export DISCO="http://localhost/disco"
fi

exec inacademia -b ${BASE} --mdx ${MDX} --cdb ${CDB} --disco ${DISCO}
