variable "config_context" {}

variable "region" {}

variable "profile" {}

variable "subnet_ids" {
  type = "list"
}

variable "vpc_id" {}

variable "elasticsearch_domain_name" {}

variable "fluentd_aws_elasticsearch_image_url" {}
