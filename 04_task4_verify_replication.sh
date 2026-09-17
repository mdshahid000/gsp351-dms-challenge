#!/usr/bin/env bash
set -Eeuo pipefail
ZONE="europe-west1-b"
VM="prd-fin-lf4"
gcloud compute ssh "$VM" --zone="$ZONE" --quiet --command="mysql -u admin -pchangeme -e \"USE customers_data; UPDATE customers SET gender='FEMALE' WHERE addressKey=934; SELECT gender FROM customers WHERE addressKey=934;\""
echo 'Source update complete. Wait at least 60 seconds for replication, then open Cloud SQL -> mysql-fin-lf4-cont -> Connect using Cloud Shell.'
echo 'Run: use customers_data; SELECT gender FROM customers WHERE addressKey=934;'
echo 'Expected destination value: FEMALE'
