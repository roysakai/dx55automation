## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_opensearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_opensearch_domain_policy.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_policy) | resource |
| [aws_opensearch_domain_policy.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anonymous_auth"></a> [anonymous\_auth](#input\_anonymous\_auth) | Whether Anonymous auth is enabled. Enables fine-grained access control on an existing domain. Ignored unless | `bool` | `false` | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Number of Availability Zones for the domain to use with zone\_awareness\_enable | `number` | `2` | no |
| <a name="input_cidrs"></a> [cidrs](#input\_cidrs) | Subnet ID | `string` | `""` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Specify the engine version for the Amazon OpenSearch Service domain. For example, OpenSearch\_1.0 or Elasticsearch\_7.9. | `string` | `"2.3"` | no |
| <a name="input_custom_endpoint"></a> [custom\_endpoint](#input\_custom\_endpoint) | Fully qualified domain for your custom endpoint | `string` | `"es.example.io"` | no |
| <a name="input_dedicated_master"></a> [dedicated\_master](#input\_dedicated\_master) | Whether dedicated main nodes are enabled for the cluster. | `bool` | `false` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Name of the domain. | `string` | `""` | no |
| <a name="input_ebs"></a> [ebs](#input\_ebs) | Whether EBS volumes are attached to data nodes in the domain | `bool` | `true` | no |
| <a name="input_encrypt_at"></a> [encrypt\_at](#input\_encrypt\_at) | Configuration block for encrypt at rest options | `bool` | `true` | no |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Whether to enable custom endpoint for the OpenSearch domain | `bool` | `false` | no |
| <a name="input_enforce_https"></a> [enforce\_https](#input\_enforce\_https) | Whether or not to require HTTPS | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Env ambient | `string` | `""` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances in the cluster | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type of data nodes in the cluster. | `string` | `"t3.small.search"` | no |
| <a name="input_internal_user"></a> [internal\_user](#input\_internal\_user) | Whether the internal user database is enabled | `bool` | `true` | no |
| <a name="input_node_encryption"></a> [node\_encryption](#input\_node\_encryption) | Configuration block for node-to-node encryption options. | `bool` | `true` | no |
| <a name="input_password"></a> [password](#input\_password) | Main user's username, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if internal\_user\_database\_enabled is set to true | `string` | n/a | yes |
| <a name="input_public_enabled"></a> [public\_enabled](#input\_public\_enabled) | Enabled type public | `bool` | `true` | no |
| <a name="input_security_advanced"></a> [security\_advanced](#input\_security\_advanced) | Whether advanced security is enabled | `bool` | `true` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security ID | `list(string)` | `[]` | no |
| <a name="input_size"></a> [size](#input\_size) | (Required if ebs\_enabled is set to true.) Size of EBS volumes attached to data nodes (in GiB) | `number` | `60` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet ID | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `null` | no |
| <a name="input_tls_security_policy"></a> [tls\_security\_policy](#input\_tls\_security\_policy) | Name of the TLS security policy that needs to be applied to the HTTPS endpoint. Valid values: Policy-Min-TLS-1-0-2019-07 and Policy-Min-TLS-1-2-2019-07 | `string` | `"Policy-Min-TLS-1-2-2019-07"` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of EBS volumes attached to data nodes | `string` | `"gp3"` | no |
| <a name="input_user"></a> [user](#input\_user) | Main user's username, which is stored in the Amazon OpenSearch Service domain's internal database. Only specify if internal\_user\_database\_enabled is set to true | `string` | `"root"` | no |
| <a name="input_vpc_enabled"></a> [vpc\_enabled](#input\_vpc\_enabled) | Enabled type vpc | `bool` | `false` | no |
| <a name="input_zone_awareness_enabled"></a> [zone\_awareness\_enabled](#input\_zone\_awareness\_enabled) | Whether zone awareness is enabled, set to true for multi-az deploymen | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account"></a> [account](#output\_account) | n/a |
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | n/a |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |



aws opensearch --endpoint-url=http://localhost:4566 describe-domains --domain-names os-development --profile local


aws ec2 --endpoint-url=http://localhost:4566 describe-instances --filters Name=tag-key,Values=Name --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}'
