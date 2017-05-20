FROM ubuntu:17.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y universe && \
    add-apt-repository -y ppa:groonga/ppa && \
    apt-get update && \
    apt-get install -y -V postgresql-9.6-pgroonga gosu build-essential

RUN locale-gen en_US.utf8 && update-locale en_US.utf8
ENV PGDATA /var/lib/postgresql/data
ENV PATH /usr/lib/postgresql/9.6/bin:$PATH
VOLUME /var/lib/postgresql/data

RUN mkdir /pg_similarity && \
    git clone https://github.com/eulerto/pg_similarity.git && \
    cd /pg_similarity && \
    USE_PGXS=1 make && \
    USE_PGXS=1 make install

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh && chown -R postgres:postgres /var/lib/postgresql/

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
