#!/usr/bin/env bash
set -Eeuo pipefail
REGION="europe-west1"
PROJECT_ID="$(gcloud config get-value project)"
SOURCE="dev-fin-vpp-source"
DEST="mysql-fin-vpp-dest"
JOB="mysql-fin-vpp-one-time"
gcloud sql instances describe mysql-fin-vpp >/dev/null || { echo 'mysql-fin-vpp not found.' >&2; exit 1; }
if ! gcloud database-migration connection-profiles describe "$DEST" --region="$REGION" >/dev/null 2>&1; then
  gcloud database-migration connection-profiles create mysql "$DEST" --region="$REGION" --display-name='mysql-fin-vpp destination' --cloudsql-instance=mysql-fin-vpp --provider=CLOUDSQL --role=DESTINATION --no-async
fi
if ! gcloud database-migration migration-jobs describe "$JOB" --region="$REGION" >/dev/null 2>&1; then
  gcloud database-migration migration-jobs create "$JOB" --region="$REGION" --type=ONE_TIME --source="$SOURCE" --destination="$DEST" --static-ip --no-async
fi
gcloud database-migration migration-jobs start "$JOB" --region="$REGION" --no-async 2>/dev/null || true
gcloud database-migration migration-jobs describe "$JOB" --region="$REGION" --format='yaml(name,state)'
echo 'Task 2 migration started. Verify customers_data count is 5030 on mysql-fin-vpp.'
