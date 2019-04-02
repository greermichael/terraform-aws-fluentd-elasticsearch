# terraform-aws-fluentd-elasticsearch

A terraform module to create an AWS ElasticSearch Service and fluentd container configured for AWS ElasticSearch into an existing kubernetes cluster.

## Assumptions
* You want to capture your Kubernetes logs into AWS ElasticSearch
* You've created a Kubernetes cluster and have a kube config available for deployment.
* You have an Fluentd AWS ElasticSearch [docker image](https://github.com/greermichael/fluentd-aws-elasticsearch)
* You have git, kubectl, helm installed

## Usage Example
```hcl
module "flentd_elasticsearch" {
    source = "github.com/greermichael/terraform-aws-fluentd-elasticsearch"
    region = "us-east-1"
    vpc_id = "vpc-123456"
    subnet_ids = ["subnet-12345","subnet-54321"]
    config_context = "my-kube-context"
    elasticsearch_domain_name = "my-es-domain"
    fluentd_aws_elasticsearch_image_url = "12345.dkr.ecr.us-east-1.amazonaws.com/aws-fluentd-elasticsearch"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| config_context | The Kubernetes context to use for deployments | string | - | yes |
| elasticsearch_dedicated_master_instance_count | Number of dedicated master instances in the elasticsearch cluster | string | `1` | no |
| elasticsearch_domain_name | Name of the Elasticsearch cluster | string | - | yes |
| elasticsearch_instance_count | Number of instances in the elasticsearch cluster | string | `1` | no |
| elasticsearch_instance_type | Instance type of the elasticsearch cluster | string | `m4.large.elasticsearch` | no |
| elasticsearch_version | Verion of Elasticsearch cluster | string | `6.4` | no |
| elasticsearch_volume_size | The size of the EBS volumes attached in GB (size per instance) | string | `10` | no |
| fluentd_aws_elasticsearch_image_tag | Image tag for Fluentd Elasticsearch docker image. | string | `latest` | no |
| fluentd_aws_elasticsearch_image_url | Location of the Fluentd Elasticsearch docker image to use | string | - | yes |
| namespace | Kubernetes namespace for logging resources | string | `logging` | no |
| region | AWS region name | string | - | yes |
| subnet_ids | List of subnet ids to host the Elasticsearch cluster | list | - | yes |
| tags | Map of tags to apply to resources | map | `<map>` | no |
| tiller_service_account | Name of the service account for Helm Tiller | string | `tiller` | no |
| vpc_id | VPC ID | string | - | yes |


## Outputs

| Name | Description |
|------|-------------|
| elasticsearch_domain_arn | - |
| elasticsearch_endpoint | - |
| kibana_endpoint | - |