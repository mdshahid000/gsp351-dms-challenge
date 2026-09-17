#!/usr/bin/env bash
set -Eeuo pipefail
ZONE="europe-west1-c"
VM="dev-fin-vpp"
DEST="mysql-fin-vpp-cont"
gcloud compute ssh "$VM" --zone="$ZONE" --quiet --command="mysql -u admin -pchangeme -e \"USE customers_data; UPDATE customers SET gender='FEMALE' WHERE addressKey=934; SELECT COUNT(*) AS source_count FROM customers;\""
echo 'Waiting for continuous replication...'
sleep 60
DEST_IP="$(gcloud sql instances describe "$DEST" --format='value(ipAddresses[0].ipAddress)')"
if command -v mysql >/dev/null 2>&1; then
  MYSQL_PWD='supersecret!' mysql --connect-timeout=15 -h "$DEST_IP" -u root -e "USE customers_data; SELECT COUNT(*) AS destination_count FROM customers; SELECT gender FROM customers WHERE addressKey=934;"
else
  echo "Run: gcloud sql connect $DEST --user=root --quiet"
  echo 'Then run: use customers_data; select gender from customers where addressKey=934;'
fi
echo 'Task 4 verification complete when the destination reflects gender=FEMALE.'
