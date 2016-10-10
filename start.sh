#!/usr/bin/env bash

# for Click library to work in satosa-saml-metadata
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# exit immediately on failure
set -e

cd ${DATA_DIR}

if [ -z "${METADATA_DIR}" ]; then
    export METADATA_DIR="."
fi
mkdir -p "${METADATA_DIR}"
# generate metadata for front- (IdP) and back-end (SP) and write it to mounted volume
satosa-saml-metadata proxy_conf.yaml metadata.key metadata.crt --dir "${METADATA_DIR}"

# start the proxy
if [[ -f https.key && -f https.crt ]]; then # if HTTPS cert is available, use it
  exec gunicorn -b0.0.0.0:${PROXY_PORT} --keyfile https.key --certfile https.crt "svs.wsgi:make_app()"
else
  exec gunicorn -b0.0.0.0:${PROXY_PORT} "svs.wsgi:make_app()"
fi