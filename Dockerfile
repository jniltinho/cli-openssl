FROM golang:alpine AS builder

# docker build --no-cache -t jniltinho/cli-openssl .
# docker run -it -v $(pwd):/tmp jniltinho/cli-openssl get-ssl --help
# docker run -it -v $(pwd):/tmp jniltinho/cli-openssl get-ssl -c google.com:443
## Caso você tenha mais de um certificado SSL no Servidor
# docker run -it jniltinho/cli-openssl get-ssl -c www.mydomain.com:443 -s www.mydomain.com

RUN set -x && apk add --no-cache curl xz tar
RUN set -x && curl -skLO https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz \
    && tar -xf upx-3.96-amd64_linux.tar.xz \   
    && cp upx-3.96-amd64_linux/upx /usr/local/bin/ \
    && rm -rf upx-3.96*

# Git is required for fetching the dependencies.
WORKDIR $GOPATH/src/jniltinho/cli-openssl/
COPY get-ssl.go .
RUN go build get-ssl.go
RUN upx get-ssl
RUN mv get-ssl /go/bin/get-ssl

FROM alpine:latest
LABEL maintainer="Nilton Oliveira jniltinho@gmail.com"
ENV TZ America/Sao_Paulo
RUN set -x \
    && apk add --no-cache openssl ca-certificates tzdata \
    && rm -rf /root/.cache /tmp/* /src \
    && rm -rf /var/cache/apk/*

COPY --from=builder /go/bin/get-ssl /usr/local/bin/get-ssl

COPY docker-entrypoint.sh /usr/local/bin/
COPY get-ssl.py /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/get-ssl.py

WORKDIR /tmp

ENTRYPOINT ["docker-entrypoint.sh"]
