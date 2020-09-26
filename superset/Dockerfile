FROM preset/superset

USER root
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY config.py /app/superset/config.py
RUN pip install requests pydruid

RUN ["chmod", "+x", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]
