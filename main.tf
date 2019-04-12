data "aws_caller_identity" "current" {}

data "template_file" "fluentd_values" {
  template = "${file("${path.module}/templates/fluentd_values.yaml.tpl")}"

  vars = {
    elasticsearch_endpoint = "https://${aws_elasticsearch_domain.logging.endpoint}"
    image_url              = "${var.fluentd_aws_elasticsearch_image_url}"
    image_tag              = "${var.fluentd_aws_elasticsearch_image_tag}"
    region                 = "${var.region}"
    logstash_prefix        = "logstash"
  }
}

resource "helm_release" "fluentd" {
  name      = "fluentd-elasticsearch"
  chart     = "stable/fluentd-elasticsearch"
  namespace = "${var.namespace}"

  values     = ["${data.template_file.fluentd_values.rendered}"]
  depends_on = ["aws_elasticsearch_domain.logging"]
}

resource "aws_elasticsearch_domain" "logging" {
  domain_name           = "${var.elasticsearch_domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"

  ebs_options {
    ebs_enabled = true
    volume_size = "${var.elasticsearch_volume_size}"
  }

  cluster_config {
    instance_count           = "${var.elasticsearch_instance_count}"
    instance_type            = "${var.elasticsearch_instance_type}"
    dedicated_master_enabled = "${var.elasticsearch_dedicated_master_instance_count > 0 ? 1 : 0}"
    dedicated_master_count   = "${var.elasticsearch_dedicated_master_instance_count}"
    zone_awareness_enabled   = "${local.enable_zone_awareness}"
  }

  vpc_options {
    # subnet_ids = ["${slice(var.subnet_ids, 0, min((var.elasticsearch_dedicated_master_instance_count > 0 ? var.elasticsearch_dedicated_master_instance_count : 1), length(var.subnet_ids)))}"]
    subnet_ids         = ["${slice(var.subnet_ids, 0, (local.enable_zone_awareness == 0 ? 1 : length(var.subnet_ids) - (length(var.subnet_ids) % 2) ))}"]
    security_group_ids = ["${aws_security_group.elasticsearch.id}"]
  }

  access_policies = "${data.aws_iam_policy_document.elasticsearch.json}"

  tags = "${merge(local.common_tags, var.tags)}"

  depends_on = ["aws_iam_service_linked_role.elasticsearch"]
}

resource "aws_security_group" "elasticsearch" {
  name   = "${var.namespace}-elasticsearch-${var.elasticsearch_domain_name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["10.0.0.0/8"]
  }
}

resource "aws_iam_service_linked_role" "elasticsearch" {
  aws_service_name = "es.amazonaws.com"
}

data "aws_iam_policy_document" "elasticsearch" {
  statement {
    sid       = "ElasticSearchAccess"
    actions   = ["es:*"]
    effect    = "Allow"
    resources = ["arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_domain_name}/*"]

    principals = {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
