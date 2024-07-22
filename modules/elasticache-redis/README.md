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
| [aws_elasticache_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.redis_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any modifications are applied immediately, or during the next maintenance window | `bool` | `false` | no |
| <a name="input_automatic-failover-enabled"></a> [automatic-failover-enabled](#input\_automatic-failover-enabled) | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, num\_cache\_clusters must be greater than 1. Must be enabled for Redis (cluster mode enabled) replication groups. | `bool` | `false` | no |
| <a name="input_az_enabled"></a> [az\_enabled](#input\_az\_enabled) | Enable cluster mode default is 'false' used in conjunction with 'multi\_az\_enabled' and automatic-failover-enabled | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Env tags | `string` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | The family of the ElastiCache parameter group | `string` | `"redis6.x"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00 | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Specifies whether to enable Multi-AZ Support for the replication group. If true, automatic\_failover\_enabled must also be enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_num_node_groups"></a> [num\_node\_groups](#input\_num\_node\_groups) | Number of node groups (shards) for this Redis replication group. Changing this number will trigger a resizing operation before other settings modifications. Conflicts with redis-instance-number | `number` | `null` | no |
| <a name="input_redis-engine-version"></a> [redis-engine-version](#input\_redis-engine-version) | Version number of the cache engine to be used for the cache clusters in this replication group | `string` | `"6.0"` | no |
| <a name="input_redis-instance-number"></a> [redis-instance-number](#input\_redis-instance-number) | Number of cache clusters (primary and replicas) this replication,  If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. Conflicts with num\_node\_groups | `number` | `null` | no |
| <a name="input_redis-instance-type"></a> [redis-instance-type](#input\_redis-instance-type) | Instance class to be used | `string` | `""` | no |
| <a name="input_redis-name"></a> [redis-name](#input\_redis-name) | Name to be used the resources as identifier | `string` | n/a | yes |
| <a name="input_redis-password"></a> [redis-password](#input\_redis-password) | Password used to access a password protected server. Can be specified only if transit\_encryption\_enabled = true | `string` | `""` | no |
| <a name="input_redis-port"></a> [redis-port](#input\_redis-port) | Port used redis | `string` | `"6379"` | no |
| <a name="input_replicas_per_node_group"></a> [replicas\_per\_node\_group](#input\_replicas\_per\_node\_group) | Number of replica nodes in each node group. Changing this number will trigger a resizing operation before other settings modifications. Valid values are 0 to 5. | `number` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | One or more Amazon VPC security groups associated with this replication group | `list(string)` | `[]` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | Number of days for which ElastiCache will retain automatic cache cluster | `number` | `1` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster | `string` | `"02:00-03:00"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet id | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_tls"></a> [tls](#input\_tls) | Whether to enable encryption in transit. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_engine"></a> [engine](#output\_engine) | The engine used |
| <a name="output_instance_arn"></a> [instance\_arn](#output\_instance\_arn) | The ARN of the instance |
| <a name="output_instance_endpoint"></a> [instance\_endpoint](#output\_instance\_endpoint) | The connection endpoint |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The instance ID |
