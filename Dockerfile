FROM alpine:latest
LABEL maintainer="Nilton Oliveira jniltinho@gmail.com"
ENV TZ America/Sao_Paulo

## docker build --no-cache -t jniltinho/docker-openssl .
## docker run -it jniltinho/docker-openssl get-ssl --help

RUN set -x \
    && apk add --no-cache openssl ca-certificates tzdata python \
    && rm -rf /root/.cache /tmp/* /src \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*


COPY docker-entrypoint.sh /usr/local/bin/
COPY get-ssl.py /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
