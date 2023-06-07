locals {
  kubernetes_common_tags = merge(local.digitalocean_thrifty_common_tags, {
    service = "DigitalOcean/Kubernetes"
  })
}

benchmark "kubernetes" {
  title         = "Kubernetes Checks"
  description   = "Thrifty developers ensure that they delete unused kubernetes resources."
  documentation = file("./controls/docs/kubernetes.md")
  children = [
    control.kubernetes_long_running
  ]

  tags = merge(local.kubernetes_common_tags, {
    type = "Benchmark"
  })
}

control "kubernetes_long_running" {
  title       = "Kubernetes clusters created over 90 days ago should be reviewed"
  description = "Kubernetes clusters created over 90 days ago should be reviewed and deleted if not required."
  severity    = "low"

  sql = <<-EOQ
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
      end as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "b.")}
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      digitalocean_kubernetes_cluster a
      left join digitalocean_region as b on b.slug = a.region_slug;
  EOQ

  tags = merge(local.droplet_common_tags, {
    class = "unused"
  })
}
