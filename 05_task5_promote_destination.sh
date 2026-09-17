#!/usr/bin/env bash
set -Eeuo pipefail
REGION="europe-west1"
JOB="mysql-fin-lf4-cont"
echo 'Promoting the continuous migration job destination...'
gcloud database-migration migration-jobs promote "$JOB" --region="$REGION"
echo 'Wait for completion, then verify:'
gcloud database-migration migration-jobs describe "$JOB" --region="$REGION" --format='yaml(name,state,phase)' || true
