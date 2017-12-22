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


COPY svs-1.0.0-py3-none-any.whl /svs-1.0.0-py3-none-any.whl
# Make sure pip is at the latest version
RUN pip3 install -U pip setuptools
RUN pip3 install /svs-1.0.0-py3-none-any.whl
RUN pip3 install pystache

COPY rsyslog.conf /etc/rsyslog.conf
COPY inacademia.conf /etc/rsyslog.d/inacademia.conf
COPY 99-inacademia.conf /etc/rsyslog.d/99-inacademia.conf
COPY start.sh /tmp/inacademia/start.sh
COPY attributemaps /tmp/inacademia/attributemaps

ENTRYPOINT ["/tmp/inacademia/start.sh"]
