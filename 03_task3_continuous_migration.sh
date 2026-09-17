#!/usr/bin/env bash
set -Eeuo pipefail
REGION="europe-west1"
gcloud database-migration connection-profiles describe prd-fin-lf4-source --region="$REGION" >/dev/null || { echo 'Run Task 1 first.' >&2; exit 1; }
gcloud sql instances describe mysql-fin-lf4-cont >/dev/null
echo 'Task 3 preflight passed. Complete this in Database Migration console:'
echo '1. Create migration job; name mysql-fin-lf4-cont; engine MySQL; destination region europe-west1; type Continuous.'
echo '2. Source profile: prd-fin-lf4-source.'
echo '3. Destination: Existing instance -> mysql-fin-lf4-cont.'
echo '4. Connectivity: VPC peering; VPC: default.'
echo '5. Test Job -> Create & start job.'
echo '6. Wait until status is Running before checking progress.'
