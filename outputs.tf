output "elasticsearch_endpoint" {
  value = "${aws_elasticsearch_domain.logging.endpoint}"
}

output "kibana_endpoint" {
  value = "${aws_elasticsearch_domain.logging.kibana_endpoint}"
}

output "elasticsearch_domain_arn" {
  value = "${aws_elasticsearch_domain.logging.arn}"
}
