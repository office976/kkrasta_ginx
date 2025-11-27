#!/bin/bash
#Install and update machine

if [ $# -ne 1 ]
then
  echo "Could not find domain. Specify it via parameter e.g. bash o365.sh DOMAIN.com"
  exit 1
fi

domain=$1

echo "Ssl in process"

certbot certonly --expand --manual --register-unsafely-without-email --agree-tos \
  --domain "${domain}" \
  --domain "*.${domain}" \
  --preferred-challenges dns

# certbot certificates

if [ $? -ne 0 ]
then
  echo "SSl failed for domain $domain"
  exit 1
fi
DefaultSSLDir="/etc/letsencrypt/archive"

if [ ! -d "$DefaultSSLDir" ]; then
  echo "Cannot Find Default SSL Directory /etc/letsencrypt/archive"
  exit 1
fi

certFile=`find /etc/letsencrypt/archive -type f -printf '%T@ %p\n' | sort -n | grep "cert" | tail -1 | cut -f2- -d" "`

privkeyFile=`find /etc/letsencrypt/archive -type f -printf '%T@ %p\n' | sort -n | grep "privkey" | tail -1 | cut -f2- -d" "`

mkdir -p /root/o365/o365/config/crt/$domain
cp $certFile /root/o365/o365/config/crt/$domain/o365.crt
cp $privkeyFile /root/o365/o365/config/crt/$domain/o365.key

exit 0