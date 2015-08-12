#!/bin/bash -e

VAULT_ADDR=${VAULT_ADDR:-https://localhost}
CONSUL_IP=`/sbin/ip route | awk '/default/ { print $3 }'`

sed -i "s;%%VAULT_ADDR%%;${VAULT_ADDR};" "/etc/consul-template.conf"
sed -i "s;%%CONSUL_IP%%;${CONSUL_IP};" "/etc/consul-template.conf"

