#!/usr/bin/env bash
set -Eeuo pipefail
PROJECT_ID="$(gcloud config get-value project)"
REGION="europe-west1"
ZONE="europe-west1-c"
VM="dev-fin-vpp"
PROFILE="dev-fin-vpp-source"
gcloud config set compute/region "$REGION" >/dev/null
gcloud config set compute/zone "$ZONE" >/dev/null
gcloud services enable datamigration.googleapis.com servicenetworking.googleapis.com sqladmin.googleapis.com
gcloud compute instances describe "$VM" --zone="$ZONE" --format='value(networkInterfaces[0].accessConfigs[0].natIP)' | tee "$HOME/gsp351-source-external-ip.txt"
SOURCE_IP="$(cat "$HOME/gsp351-source-external-ip.txt")"
[[ -n "$SOURCE_IP" ]] || { echo 'No external IP found for dev-fin-vpp.' >&2; exit 1; }
if ! gcloud database-migration connection-profiles describe "$PROFILE" --region="$REGION" >/dev/null 2>&1; then
  gcloud database-migration connection-profiles create mysql "$PROFILE" --region="$REGION" --display-name='dev-fin-vpp source' --host="$SOURCE_IP" --port=3306 --username=admin --password=changeme --ssl-type=NONE --no-async
else
  echo "Connection profile $PROFILE already exists; reusing it."
fi
echo 'Task 1 complete. Profile and external source IP are ready.'
