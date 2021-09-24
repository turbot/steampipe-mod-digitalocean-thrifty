## Thrifty Block Storage Benchmark

Thrifty developers eliminate their unused and under-utilized block volume resources. This benchmark focuses on finding resources which are older than thresholds days, have large size, unused volumes.

## Variables

| Variable | Description | Default |
| - | - | - |
| block_storage_volume_max_size_gb | The maximum size in GB allowed for volumes. | 100 GB |
| block_storage_volume_snapshot_age_max_days | The maximum number of days a snapshot can be retained. | 90 days |
