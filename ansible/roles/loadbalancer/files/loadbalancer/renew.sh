#!/bin/bash

docker exec -it certbot certbot renew --force-renewal
docker exec -it reverse-proxy nginx -s reload
