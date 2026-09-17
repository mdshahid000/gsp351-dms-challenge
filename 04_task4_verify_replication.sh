#!/usr/bin/env bash
set -Eeuo pipefail
ZONE="europe-west1-c"
VM="dev-fin-vpp"
DEST="mysql-fin-vpp-cont"
JOB="mysql-fin-vpp-cont"
STATE="$(gcloud database-migration migration-jobs describe "$JOB" --region=europe-west1 --format='value(state)' 2>/dev/null || true)"
echo "Migration job state: ${STATE:-not-found}"
if [[ "$STATE" != "RUNNING" && "$STATE" != "COMPLETED" ]]; then
  echo 'Task 3 must reach RUNNING before Task 4. Do not continue until the DMS job is running.' >&2
  exit 2
fi
gcloud compute ssh "$VM" --zone="$ZONE" --quiet --command="mysql -u admin -pchangeme -e \"USE customers_data; UPDATE customers SET gender='FEMALE' WHERE addressKey=934; SELECT COUNT(*) AS source_count FROM customers;\""
echo 'Waiting for the continuous migration to apply the update and create customers_data on the destination...'
for i in {1..24}; do
  if gcloud sql databases describe customers_data --instance="$DEST" >/dev/null 2>&1; then
    echo 'customers_data is available on the destination.'
    break
  fi
  echo "Waiting for destination initial dump ($i/24)..."; sleep 15
done
if ! gcloud sql databases describe customers_data --instance="$DEST" >/dev/null 2>&1; then
  echo 'customers_data is still missing on mysql-fin-vpp-cont. Check Task 3 DMS job and destination instance.' >&2
  exit 1
fi
DEST_IP="$(gcloud sql instances describe "$DEST" --format='value(ipAddresses[0].ipAddress)')"
if command -v mysql >/dev/null 2>&1; then
  MYSQL_PWD='supersecret!' mysql --connect-timeout=15 -h "$DEST_IP" -u root -e "USE customers_data; SELECT COUNT(*) AS destination_count FROM customers; SELECT gender FROM customers WHERE addressKey=934;"
else
  echo "Run: gcloud sql connect $DEST --user=root --quiet"
  echo 'Then run: use customers_data; select gender from customers where addressKey=934;'
fi
echo 'Task 4 verification complete when the destination reflects gender=FEMALE.'
