
FROM golang:alpine AS builder

# docker build --no-cache -t jniltinho/cli-openssl .
# docker run -it jniltinho/cli-openssl get-ssl --help
# docker run -it jniltinho/cli-openssl get-ssl -c google.com:443
## Caso você tenha mais de um certificado SSL no Servidor
# docker run -it jniltinho/cli-openssl get-ssl -c www.mydomain.com:443 -s www.mydomain.com

# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/jniltinho/cli-openssl/
COPY get-ssl.go .
#RUN go get -d -v
RUN go build get-ssl.go -o /go/bin/get-ssl


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

ENTRYPOINT ["docker-entrypoint.sh"]
