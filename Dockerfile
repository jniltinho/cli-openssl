FROM docker:stable-dind

ENV TZ=America/Sao_Paulo


RUN set -x \
    && apk add --no-cache openssl ca-certificates tzdata python \
    && rm -rf /root/.cache /tmp/* /src \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*


COPY docker-entrypoint.sh /usr/local/bin/
COPY get-ssl.py /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
