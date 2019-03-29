data "aws_caller_identity" "current" {}

data "template_file" "fluentd_values" {
  template = "${file("${path.module}/templates/fluentd_values.yaml.tpl")}"

  vars = {
    elasticsearch_endpoint              = "https://${aws_elasticsearch_domain.logging.endpoint}"
    fluentd_aws_elasticsearch_image_url = "${var.fluentd_aws_elasticsearch_image_url}"
    region                              = "${var.region}"
    logstash_prefix                     = "logstash"
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

  vpc_options {
    subnet_ids = ["${var.subnet_ids[0]}"]

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
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
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
