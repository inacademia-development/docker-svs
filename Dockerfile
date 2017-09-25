FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-dev \
    build-essential \
    python3-pip \
    libffi-dev \
    libssl-dev \
    xmlsec1 \
    libyaml-dev \ 
    rsyslog
RUN apt clean

RUN pip3 install --upgrade pip setuptools
RUN pip3 install git+git://github.com/rohe/pysaml2.git#egg=pysaml2
# Use this until we transfer it to GEANT
RUN pip3 install git+git://github.com/jkakavas/svs.git#egg=svs
# Use jkakavas/satosa until the custom error handling is merged in satosa
RUN pip3 install git+git://github.com/jkakavas/SATOSA.git#egg=SATOSA
RUN pip3 install pystache

COPY rsyslog.conf /etc/rsyslog.conf
COPY inacademia.conf /etc/rsyslog.d/inacademia.conf
COPY 99-inacademia.conf /etc/rsyslog.d/99-inacademia.conf
COPY start.sh /tmp/inacademia/start.sh
COPY attributemaps /tmp/inacademia/attributemaps

ENTRYPOINT ["/tmp/inacademia/start.sh"]
