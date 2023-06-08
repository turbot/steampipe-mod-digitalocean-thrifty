locals {
  network_common_tags = merge(local.digitalocean_thrifty_common_tags, {
    service = "DigitalOcean/Network"
  })
}

benchmark "network" {
  title         = "Network Checks"
  description   = "Thrifty developers ensure that they delete unused network resources."
  documentation = file("./controls/docs/network.md")
  children = [
    control.network_floating_ip_unattached,
    control.network_load_balancer_unused
  ]

  tags = merge(local.network_common_tags, {
    type = "Benchmark"
  })
}

control "network_floating_ip_unattached" {
  title       = "Unattached floating IP addresses should be released"
  description = "Unattached floating IPs cost money and should be released."
  severity    = "low"

  sql = <<-EOQ
    select
      ip.urn as resource,
      case
        when ip.droplet_id is null then 'alarm'
        else 'ok'
      end as status,
      case
        when ip.droplet_id is null then ip.title || ' not attached.'
        else ip.title || ' is attached.'
      end as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "ip.")}
    from
      digitalocean_floating_ip as ip
      left join digitalocean_region as r on r.slug = ip.region_slug;
  EOQ

  tags = merge(local.network_common_tags, {
    class = "unused"
  })
}

control "network_load_balancer_unused" {
  title       = "Load balancers not assigned to any droplet should be reviewed"
  description = "Load balancers are charged on an hourly basis. Unused load balancers should be reviewed, if not assigned to any droplets."
  severity    = "low"

  sql = <<-EOQ
    select
      b.urn as resource,
      case
        when jsonb_array_length(b.droplet_ids) < 1 then 'alarm'
        else 'ok'
      end as status,
      b.title || ' assigned with ' || jsonb_array_length(b.droplet_ids) || ' droplet(s).' as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "b.")}
    from
      digitalocean_load_balancer as b
      left join digitalocean_region as r on r.slug = b.region_slug;
  EOQ

  tags = merge(local.network_common_tags, {
    class = "unused"
  })
}