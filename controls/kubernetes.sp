locals {
  kubernetes_common_tags = merge(local.thrifty_common_tags, {
    service = "kubernetes"
  })
}

benchmark "kubernetes" {
  title         = "Kubernetes Checks"
  description   = "Thrifty developers ensure delete unused kubernetes resources."
  documentation = file("./controls/docs/database.md")
  tags          = local.database_common_tags
  children = [
    control.kubernetes_long_running
  ]
}

control "kubernetes_long_running" {
  title       = "Kubernetes created over 90 days ago should be reviewed"
  description = "Kubernetes created over 90 days ago should be reviewed and deleted if not required."
  severity    = "low"

  sql = <<-EOT
    select
      a.urn as resource,
      case
        when status = 'deleted' then 'skip'
        when date_part('day', now() - created_at) > 90
        and status in ('invalid', 'error') then 'alarm'
        when date_part('day', now() - created_at) > 90 then 'info'
        else 'ok'
      end as status,
      case
        when status = 'deleted' then ' SKIP'
        when date_part('day', now() - created_at) > 90 and status in ('invalid', 'error')
        then a.title || ' instance status is ' || status || ', has been launced for ' || date_part('day', now() - created_at) || ' day(s).'
        else a.title || ' has been launced for ' || date_part('day', now() - created_at) || ' day(s).'
      end as reason,
      b.name as region
    from
      digitalocean_kubernetes_cluster a
      left join digitalocean_region as b on b.slug = a.region_slug
  EOT

  tags = merge(local.droplet_common_tags, {
    class = "unused"
  })
}