FROM ubuntu:14.04
MAINTAINER InAcademia Team, tech@inacademia.org

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    python-dev \
    libffi-dev \
    python-openssl \
    python-pip \
    xmlsec1 \
    libldap2-dev \
    libsasl2-dev

COPY requirements.txt start.sh /tmp/inacademia/

RUN pip install --upgrade pip
RUN pip install -r /tmp/inacademia/requirements.txt && \
    pip install git+https://github.com/its-dirg/svs.git@v0.2.2#egg=svs

EXPOSE 8087

ENTRYPOINT ["/tmp/inacademia/start.sh"]
