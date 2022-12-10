variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
    type = string
    default = "us-central1-a"
}

variable "terraform_service_account" {
    type = string
}

variable "default_service_account" {
    type = string
}

variable "network_subnet_0_cidr" {
    type = string
    default = "10.1.0.0/24"
}

variable "prefix" {
    type = string
    default = "bnm"
}
