#!/bin/bash

docker exec -it certbot certbot renew --force-renewal
docker exec -it reverse-proxy nginx -s reload

docker cp -L /etc/letsencrypt/live/mail.peltops.com/fullchain.pem iredmail:/opt/iredmail/ssl/combined.pem
docker cp -L /etc/letsencrypt/live/mail.peltops.com/privkey.pem iredmail:/opt/iredmail/ssl/key.pem
docker cp -L /etc/letsencrypt/live/mail.peltops.com/cert.pem iredmail:/opt/iredmail/ssl/cert.pem
docker exec -it iredmail nginx -s reload