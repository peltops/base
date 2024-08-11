# Supabase install
## Install
```
# ansible-playbook -i inventory/base.ini --private-key=<private-key> playbook/supabase.yaml
```
## Delete
```
# docker compose -f docker-compose.yaml -f docker-compose-s3.yaml down
# rm -rf volumes
```