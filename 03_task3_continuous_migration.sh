#!/usr/bin/env bash
set -Eeuo pipefail
REGION="europe-west1"
PROJECT_ID="$(gcloud config get-value project)"
SOURCE="dev-fin-vpp-source"
DEST="mysql-fin-vpp-cont-dest"
JOB="mysql-fin-vpp-cont"
gcloud sql instances describe mysql-fin-vpp-cont >/dev/null || { echo 'mysql-fin-vpp-cont not found.' >&2; exit 1; }
if ! gcloud database-migration connection-profiles describe "$DEST" --region="$REGION" >/dev/null 2>&1; then
  gcloud database-migration connection-profiles create mysql "$DEST" --region="$REGION" --display-name='mysql-fin-vpp-cont destination' --cloudsql-instance=mysql-fin-vpp-cont --provider=CLOUDSQL --role=DESTINATION --no-async
fi
if ! gcloud database-migration migration-jobs describe "$JOB" --region="$REGION" >/dev/null 2>&1; then
  gcloud database-migration migration-jobs create "$JOB" --region="$REGION" --type=CONTINUOUS --source="$SOURCE" --destination="$DEST" --peer-vpc="projects/$PROJECT_ID/global/networks/default" --no-async
fi
gcloud database-migration migration-jobs start "$JOB" --region="$REGION" --no-async 2>/dev/null || true
gcloud database-migration migration-jobs describe "$JOB" --region="$REGION" --format='yaml(name,state)'
echo 'Task 3 complete when mysql-fin-vpp-cont job state is RUNNING.'
