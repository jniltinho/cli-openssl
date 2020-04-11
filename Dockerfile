FROM golang:alpine AS builder

# docker build --no-cache -t jniltinho/cli-openssl .
# docker run -it -v $(pwd):/tmp jniltinho/cli-openssl get-ssl --help
# docker run -it -v $(pwd):/tmp jniltinho/cli-openssl get-ssl -c google.com:443
## Caso você tenha mais de um certificado SSL no Servidor
# docker run -it jniltinho/cli-openssl get-ssl -c www.mydomain.com:443 -s www.mydomain.com

RUN set -x && apk add --no-cache curl xz tar git unzip
RUN set -x && curl -skLO https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz \
    && tar -xf upx-3.96-amd64_linux.tar.xz \   
    && cp upx-3.96-amd64_linux/upx /usr/local/bin/ \
    && rm -rf upx-3.96*

RUN set -x && curl -skLO https://github.com/mayflower/docker-ls/releases/download/v0.3.2/docker-ls-linux-amd64.zip \
    && unzip docker-ls-linux-amd64.zip \
    && mv docker-ls /usr/local/bin/ \
    && upx /usr/local/bin/docker-ls

RUN set -x && curl -skLO https://github.com/girigiribauer/go-pwgen/releases/download/v0.2.1/pw-linux-amd64.tar.gz \
    && tar -xf pw-linux-amd64.tar.gz \
    && mv pw /usr/local/bin/pw \
    && upx /usr/local/bin/pw


# Git is required for fetching the dependencies.
WORKDIR $GOPATH/src/github.com/jniltinho/cli-openssl/
COPY . .
RUN go get -d -v

RUN go build -o /usr/local/bin/get-ssl
RUN upx /usr/local/bin/get-ssl
RUN ls -sh /usr/local/bin/get-ssl

FROM alpine:latest
LABEL maintainer="Nilton Oliveira jniltinho@gmail.com"
ENV TZ America/Sao_Paulo
RUN set -x \
    && apk add --no-cache openssl ca-certificates tzdata \
    && rm -rf /root/.cache /tmp/* /src \
    && rm -rf /var/cache/apk/*

COPY --from=builder /usr/local/bin/get-ssl /usr/local/bin/get-ssl
COPY --from=builder /usr/local/bin/docker-ls /usr/local/bin/docker-ls
COPY --from=builder /usr/local/bin/pw /usr/local/bin/pw

COPY docker-entrypoint.sh /usr/local/bin/
COPY get-ssl.py /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/get-ssl.py

WORKDIR /tmp

ENTRYPOINT ["docker-entrypoint.sh"]
