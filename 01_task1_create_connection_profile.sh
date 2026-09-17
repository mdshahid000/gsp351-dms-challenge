#!/usr/bin/env bash
set -Eeuo pipefail
REGION="europe-west1"
ZONE="europe-west1-b"
VM="prd-fin-lf4"
PROFILE="prd-fin-lf4-source"
gcloud config set compute/region "$REGION" >/dev/null
gcloud config set compute/zone "$ZONE" >/dev/null
gcloud services enable datamigration.googleapis.com servicenetworking.googleapis.com sqladmin.googleapis.com
SOURCE_IP="$(gcloud compute instances describe "$VM" --zone="$ZONE" --format='value(networkInterfaces[0].accessConfigs[0].natIP)')"
[[ -n "$SOURCE_IP" ]] || { echo 'External IP not found.' >&2; exit 1; }
printf '%s\n' "$SOURCE_IP" > "$HOME/gsp351-source-external-ip.txt"
if ! gcloud database-migration connection-profiles describe "$PROFILE" --region="$REGION" >/dev/null 2>&1; then
  gcloud database-migration connection-profiles create mysql "$PROFILE" --region="$REGION" --display-name="$PROFILE" --host="$SOURCE_IP" --port=3306 --username=admin --password=changeme --ssl-type=NONE --no-async
fi
echo "Task 1 complete. Source profile: $PROFILE; external IP: $SOURCE_IP"
