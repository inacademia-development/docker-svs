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

RUN pip3 install --upgrade pip setuptools
RUN pip3 install git+git://github.com/leifj/pysaml2.git#egg=pysaml2
RUN pip3 install git+git://github.com/jkakavas/svs.git#egg=svs
RUN pip3 install git+git://github.com/sunet/SATOSA.git#egg=SATOSA
RUN pip3 install pystache
COPY 99-inacademia.conf /etc/rsyslog.d/99-inacademia.conf
COPY start.sh /tmp/inacademia/start.sh
COPY attributemaps /tmp/inacademia/attributemaps
ENTRYPOINT ["/tmp/inacademia/start.sh"]
