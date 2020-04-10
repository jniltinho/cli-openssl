# docker-openssl
Docker OpenSSL

## Usando a Imagem com OpenSSL

```
docker build --no-cache -t jniltinho/cli-openssl .
docker run -it jniltinho/cli-openssl get-ssl.py --help
docker run -it jniltinho/cli-openssl get-ssl.py -c google.com:443

## Caso você tenha mais de um certificado SSL no Servidor
docker run -it jniltinho/cli-openssl get-ssl.py -c www.mydomain.com:443 -s www.mydomain.com
```

## Fazendo o Build

```bash
git clone https://github.com/jniltinho/cli-openssl.git
cd docker-openssl.git
docker build --no-cache -t cli-openssl .
```
