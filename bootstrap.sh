#!/bin/bash -e

VAULT_ADDR=${VAULT_ADDR:-https://localhost}
CONSUL_IP=`/sbin/ip route | awk '/default/ { print $3 }'`

sed -i "s;%%VAULT_ADDR%%;${VAULT_ADDR};" "/etc/consul-template.conf"
sed -i "s;%%CONSUL_IP%%;${CONSUL_IP};" "/etc/consul-template.conf"


cat /dev/shm/.token | tr -d '\n' > /root/.vault-token
export VAULT_TOKEN=`cat /dev/shm/.token | tr -d '\n'`
export APPNAME=${APPNAME:-apptest}
export POLICY=${POLICY:-none}
export APPID=$(uuidgen)
if [ -z ${ENVIRONMENT} ]; then ENVIRONMENT=ci; fi
vault write auth/app-id/map/app-id/${APPID} value=${POLICY} display_name=${APPNAME}
vault write auth/app-id/map/user-id/${APPNAME} value=${APPID}
rm ~/.vault-token
unset VAULT_TOKEN
echo ${APPID}
export TOKEN=`curl -s --data "{\"app_id\":\"${APPID}\",\"user_id\":\"${APPNAME}\"}" ${VAULT_ADDR}/v1/auth/app-id/login | \
         sed -e 's/^.*"client_token":"\([^"]*\)".*$/\1/'`
echo ${TOKEN}
echo -n "${TOKEN}" > ~/.vault-token
