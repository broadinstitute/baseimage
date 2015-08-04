#!/bin/bash

VAULT_ADDR=${VAULT_ADDR:-https://localhost}
CONSUL_IP=`/sbin/ip route | awk '/default/ { print $3 }'`

sed -i "s;%%VAULT_ADDR%%;${VAULT_ADDR};" "/etc/consul-template.conf"
sed -i "s;%%CONSUL_IP%%;${CONSUL_IP};" "/etc/consul-template.conf"


APPNAME=${APPNAME:-apptest}
POLICY=${POLICY:-none}
APPID=$(uuidgen)
if [ -z ${ENVIRONMENT} ]; then ENVIRONMENT=ci; fi
vault write auth/app-id/map/app-id/${APPID} value=${POLICY} display_name=${APPNAME}
vault write auth/app-id/map/user-id/${APPNAME} value=${APPID}
echo ${APPID}
TOKEN=`curl -s --data "{\"app_id\":\"${APPID}\",\"user_id\":\"${APPNAME}\"}" ${VAULT_ADDR}/v1/auth/app-id/login | \
         sed -e 's/^.*"client_token":"\([^"]*\)".*$/\1/'`
echo ${TOKEN}
echo -n "${TOKEN}" > ~/.vault-token
export VAULT_TOKEN=${TOKEN}
