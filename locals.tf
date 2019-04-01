locals {
  common_tags           = {}
  enable_zone_awareness = "${min(var.elasticsearch_dedicated_master_instance_count, var.elasticsearch_instance_count) > 1 && length(var.subnet_ids) > 1 ? 1 : 0}"
}
