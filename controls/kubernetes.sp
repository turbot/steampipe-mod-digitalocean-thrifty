variable "kubernetes_running_cluster_age_max_days" {
  type        = number
  description = "The maximum number of days a kubernetes cluster is allowed to run."
}

locals {
  kubernetes_common_tags = merge(local.thrifty_common_tags, {
    service = "kubernetes"
  })
}

benchmark "kubernetes" {
  title         = "Kubernetes Checks"
  description   = "Thrifty developers ensure that they delete unused kubernetes resources."
  documentation = file("./controls/docs/kubernetes.md")
  tags          = local.kubernetes_common_tags
  children = [
    control.kubernetes_long_running
  ]
}

control "kubernetes_long_running" {
  title       = "Long running Kubernetes clusters should be reviewed"
  description = "Long running Kubernetes clusters should be reviewed and deleted if not required."
  severity    = "low"

  sql = <<-EOT
    select
      a.urn as resource,
      case
        when status = 'deleted' then 'skip'
        when date_part('day', now() - created_at) > $1
        and status in ('invalid', 'error') then 'alarm'
        when date_part('day', now() - created_at) > $1 then 'info'
        else 'ok'
      end as status,
      case
        when status = 'deleted' then ' SKIP'
        when date_part('day', now() - created_at) > $1 and status in ('invalid', 'error')
        then a.title || ' instance status is ' || status || ', has been launched for ' || date_part('day', now() - created_at) || ' day(s).'
        else a.title || ' has been launched for ' || date_part('day', now() - created_at) || ' day(s).'
      end as reason,
      b.name as region
    from
      digitalocean_kubernetes_cluster as a
      left join digitalocean_region as b on b.slug = a.region_slug;
  EOT

  param "kubernetes_running_cluster_age_max_days" {
    description = "The maximum number of days a kubernetes cluster is allowed to run."
    default = var.kubernetes_running_cluster_age_max_days
  }

  tags = merge(local.kubernetes_common_tags, {
    class = "unused"
  })
}
