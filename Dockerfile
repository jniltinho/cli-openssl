FROM docker:stable-dind

ENV TZ=America/Sao_Paulo


RUN set -x \
    && apk add --no-cache openssl ca-certificates tzdata \
    && rm -rf /root/.cache /tmp/* /src \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

ENTRYPOINT [ "/usr/bin/openssl" ]
