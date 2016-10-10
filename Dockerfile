FROM itsdirg/satosa
MAINTAINER InAcademia Team, tech@inacademia.org

COPY start.sh /tmp/inacademia/

COPY svs-1.0.0-py3-none-any.whl /svs-1.0.0-py3-none-any.whl
RUN pip3 install /svs-1.0.0-py3-none-any.whl

ENTRYPOINT ["/tmp/inacademia/start.sh"]
