## Thrifty Database Benchmark

Thrifty developers ensure that they delete unused database resources. This benchmark focuses on finding resources that have been older than thresholds days.

## Variables

| Variable | Description | Default |
| - | - | - |
| database_running_cluster_age_max_days | The maximum number of days database clusters are allowed to run. | 90 days |
| database_running_cluster_age_warning_days | The number of days database clusters can be running before sending a warning. | 30 days |
