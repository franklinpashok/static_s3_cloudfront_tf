# AWS S3 Terraform module


## Input Variables

|           Input Variable           |    Type     |
| :--------------------------------: | :---------: |
|            bucket_name             |   string    |
|         versioning_enabled         |    bool     |
|                acl                 |   string    |
|         block_public_acls          |    bool     |
|        block_public_policy         |    bool     |
|         ignore_public_acls         |    bool     |
|      restrict_public_buckets       |    bool     |
|           bucket_policy            |   string    |
|       lifecycle_rule_enabled       |    bool     |
| noncurrent_version_expiration_days |   number    |
|    expired_object_delete_marker    |    bool     |
|                tags                | map(string) |
|server_side_encryption_configuration| map(string) |


## Ouputs

|   Output    |          Description           |
| :---------: | :----------------------------: |
| bucket_name | The name of the created bucket |
