FROM postgres:16-alpine

WORKDIR /docker-entrypoint-initdb.d

COPY sql/ ./sql/

ENV POSTGRES_DB=mydb
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

RUN ls -la ./sql/

CMD ["postgres"]
