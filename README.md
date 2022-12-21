# Terraform BigQuery / Logs Sink Demo
Demonstrate using Terraform to automate the creation of a BigQuery dataset and a logs sink to populate it.

![image](https://raw.githubusercontent.com/bmullan-google/gc-tf-bq-logs/main/Terraform-BigQuery-LogSink-Demo.png)

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
- A Cloud Router
- A Cloud nat gateway
- A GCE instance running apache web server
- A BigQuery Dataset
- A Logs sink that sinks apache web server logs to a table in the BigQuery dataset

## Test the setup
- Note this vm does not have a public ip address (security best practice)
- To access it you will start an iap tunnel. The terraform output will include the command to start the tunnel eg. 
```
gcloud compute start-iap-tunnel bql-apache-http-server 80 --local-host-port=localhost:8080
```
- This will map port 80 on the apache web server to port 8080 on your localhost machine eg. 
```
gcloud compute start-iap-tunnel bql-apache-http-server 80 --local-host-port=localhost:8080
Testing if tunnel connection works.
Listening on port [8080].
```
- Now you can exercise the apache server by creating a request to the web server eg. (you can run this command multiple times)

```
curl localhost:8080
```

- Go to Cloud Console and review Logging -> Logs Explorer
- Go to BigQuery and review the dataset and table.

### Things to try
- Create a query on the logs table in BigQuery
