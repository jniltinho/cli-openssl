#!/usr/bin/env python
# -*- coding: utf-8 -*-
## Versao 0.1

"""
Script de Backup MYSQL (get-ssl.py)
Copyrighted by Nilton OS <jniltinho at gmail.com>
License: LGPLv3 (http://www.gnu.org/licenses/lgpl.html)

 Como utilizar:
  - python get-ssl.py -c www.domain.com:443
  - python get-ssl.py -s www.domain.com -c www.domain.com:443
"""


import os, sys, optparse


def show_ssl_server(server_name, connect):
    cmd = ("echo|openssl s_client -servername %s -connect %s 2>/dev/null|openssl x509" % (server_name, connect))
    os.system(cmd) 


def show_ssl(connect):
    cmd = ("echo|openssl s_client -connect %s 2>/dev/null|openssl x509" % (connect))
    os.system(cmd) 


def main():
    usage = "Usage: %prog -c www.domain.com:443 \nUsage: %prog -s www.domain.com -c www.domain.com:443"
    parser = optparse.OptionParser(usage)
    parser.add_option("-s", "--servername", action="store", type="string", dest="SERVER_NAME", help="Host Name = www.domain.com")
    parser.add_option("-c", "--connect", action="store", type="string", dest="URL_PORT", help="URL:PORT =  www.domain.com:443")
    options, args = parser.parse_args()
    

    if (options.SERVER_NAME and options.URL_PORT):
        show_ssl_server(options.SERVER_NAME, options.URL_PORT)
        sys.exit(0)

    if (options.URL_PORT):
        show_ssl(options.URL_PORT)
        sys.exit(0)


if __name__ == "__main__":
    main()
