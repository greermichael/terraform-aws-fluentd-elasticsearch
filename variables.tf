variable "config_context" {
  description = "The Kubernetes context to use for deployments"
}

variable "region" {
  description = "AWS region name"
}

variable "namespace" {
  description = "Kubernetes namespace for logging resources"
  default     = "logging"
}

variable "tiller_service_account" {
  description = "Name of the service account for Helm Tiller"
  default     = "tiller"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "subnet_ids" {
  description = "List of subnet ids to host the Elasticsearch cluster"
  type        = "list"
}

variable "fluentd_aws_elasticsearch_image_url" {
  description = "Location of the Fluentd Elasticsearch docker image to use"
}

variable "elasticsearch_domain_name" {
  description = "Name of the Elasticsearch cluster"
}

variable "elasticsearch_version" {
  description = "Verion of Elasticsearch cluster"
  default     = "6.4"
}

variable "elasticsearch_volume_size" {
  description = "The size of the EBS volumes attached in GB"
  default     = 20
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = "map"
  default     = {}
}
