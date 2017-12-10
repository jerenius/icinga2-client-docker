#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "Icinga2 installed, configuring..."

PKI_DIR="/etc/icinga2/pki"

echo "$MASTER_IP $MASTER_HOST" >>/etc/hosts
echo "127.0.2.1 $CLIENT_HOST" >>/etc/hosts

chown nagios.nagios /etc/icinga2 -R

rm -rf /etc/icinga2/conf.d/*

echo "curl -k -s -u $API_USER:$API_PWD -H 'Accept: application/json' -X POST \"https://$MASTER_IP:5665/v1/actions/generate-ticket\" -d '{ \"cn\": \"$CLIENT_HOST\" }'">/opt/ticket.sh

ICINGA_TICKET=`sh /opt/ticket.sh | awk -F\" '{print $12}'`


icinga2 pki new-cert --cn $CLIENT_HOST --key $PKI_DIR/$CLIENT_HOST.key --cert $PKI_DIR/$CLIENT_HOST.crt
icinga2 pki save-cert --key $PKI_DIR/$CLIENT_HOST.key --cert $PKI_DIR/$CLIENT_HOST.crt --trustedcert $PKI_DIR/trusted-cert.crt --host $MASTER_HOST
icinga2 node setup --ticket $ICINGA_TICKET --zone $CLIENT_HOST --master_host $MASTER_HOST  --trustedcert  $PKI_DIR/trusted-cert.crt  --cn $CLIENT_HOST  --endpoint $MASTER_HOST,$MASTER_IP,5665 --accept-commands --accept-config

sed -i '$ i object Zone "global-templates" { global = true }' /etc/icinga2/zones.conf
sed -i '$ i object Zone "director-global" { global = true }' /etc/icinga2/zones.conf

chmod u+s,g+s /bin/ping
chmod u+s,g+s /bin/ping6
chmod u+s,g+s /usr/lib/nagios/plugins/check_icmp
















## Start supervisord
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf -n &
trap "supervisorctl shutdown && wait" SIGTERM
wait
