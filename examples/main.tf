provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

module "logging" {
  source                              = "../"
  region                              = "${var.region}"
  vpc_id                              = "${var.vpc_id}"
  subnet_ids                          = "${var.subnet_ids}"
  config_context                      = "${var.config_context}"
  elasticsearch_domain_name           = "${var.elasticsearch_domain_name}"
  fluentd_aws_elasticsearch_image_url = "${var.fluentd_aws_elasticsearch_image_url}"
}

output "kibana_endpoint" {
  value = "${module.logging.kibana_endpoint}"
}
