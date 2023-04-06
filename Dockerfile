FROM postgres:15.2-alpine

ENV POSTGRES_DB mm_database
ENV POSTGRES_USER root
ENV POSTGRES_PASSWORD foo

COPY schema.sql /docker-entrypoint-initdb.d/
