#!/bin/bash

export TERRAFORM_SA_ID=terraform

gcloud iam service-accounts create $TERRAFORM_SA_ID \
  --project=$PROJECT_ID

declare -a roles=("roles/compute.networkAdmin" "roles/bigquery.admin" "roles/compute.admin" "roles/logging.admin" "roles/iam.serviceAccountUser" "roles/resourcemanager.projectIamAdmin")

echo "adding roles ..."

for i in "${roles[@]}"
do
   echo "$i"
   gcloud projects add-iam-policy-binding $PROJECT_ID  \
  --member="serviceAccount:$TERRAFORM_SA_ID@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="$i" --no-user-output-enabled
done

