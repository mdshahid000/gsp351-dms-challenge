#!/usr/bin/env bash
set -Eeuo pipefail
REGION="europe-west1"
JOB="mysql-fin-vpp-cont"
gcloud database-migration migration-jobs promote "$JOB" --region="$REGION"
gcloud database-migration migration-jobs describe "$JOB" --region="$REGION" --format='yaml(name,state)' || true
echo 'Task 5 complete when the migration job is COMPLETED and mysql-fin-vpp-cont is standalone.'
