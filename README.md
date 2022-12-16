# Terraform BigQuery / Logs Sink Demo
Demonstrate using Terraform to automate the creation of a BigQuery dataset and a logs sink to populate it.

## Setup your environment
- Start a Google Cloud shell

- clone the repository

```
git clone https://github.com/bmullan-google/gc-tf-bq-logs
cd gc-tf-bq-logs
```


- verify connectivity & setup vars

```
gcloud auth list
gcloud config list project
export PROJECT_ID=$DEVSHELL_PROJECT_ID
echo $PROJECT_ID
```

- Create a terraform service account

```
export TERRAFORM_SA_ID=terraform
./create-service-account.sh
```

- If running in argolis, set org policies

```
./set-argolis-org-policies.sh
```

- Set terraform env variables

```
export TF_VAR_project_id=$PROJECT_ID
export TF_VAR_region=us-central1
export TF_VAR_zone=us-central1-a
export TF_VAR_terraform_service_account=$TERRAFORM_SA_ID
```

## Create the Google Cloud Infrastructure

```
terraform init
terraform plan
terraform apply --auto-approve
```

This will create the following resources ...
- A VPC
- A VPC subnet
- A GCE instance running apache web server
- A BigQuery Dataset
- A Logs sink that sinks apache web server logs to a table in the BigQuery dataset

## Test the setup

- Exercise the apache server. From the output from running terraform you should have the ip of the apache web server eg. 

```
Outputs:
instance_ip_addr = "35.202.157.172"
```

Create a request to the web server

```
curl 35.202.157.172
```

Alternatively install the "siege" tool to load test the server

```
sudo apt install siege -y
```

And run it with the following command for a few seconds

```
siege <ip-address>
```

- Go to Cloud Console and review Logging -> Logs Explorer
- Go to BigQuery and review the dataset and table.

### Things to try
- Create a query on the logs table in BigQuery
