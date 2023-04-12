FROM postgres:15.2-alpine

ENV POSTGRES_DB mm_database
ENV POSTGRES_USER root
ENV POSTGRES_PASSWORD foo

COPY schema.sh /docker-entrypoint-initdb.d/
COPY initdb/* /tmp/

CMD ["postgres", "-c", "max_wal_size=2GB"]
