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

  sql = <<-EOT
    select
      -- Required Columns
      urn as resource,
      case
        when droplet_id is null then 'alarm'
        else 'ok'
      end as status,
      case
        when droplet_id is null then title || ' not attached.'
        else title || ' is attached.'
      end as reason,
      -- Additional Dimensions
      region ->> 'name'
    from
      digitalocean_floating_ip;
  EOT

  tags = merge(local.network_common_tags, {
    class = "unused"
  })
}

control "network_load_balancer_unused" {
  title         = "Load balancers not assigned to any droplet should be reviewed"
  description   = "Load balancers are charged on an hourly basis. Unused load balancers should be reviewed, if not assigned to any droplets."
  severity      = "low"

  sql = <<-EOT
    select
      -- Required Columns
      urn as resource,
      case
        when jsonb_array_length(droplet_ids) < 1 then 'alarm'
        else 'ok'
      end as status,
      title || ' assigned with ' || jsonb_array_length(droplet_ids) || ' droplet(s).' as reason,
      -- Additional Dimensions
      region_name
    from
      digitalocean_load_balancer;
  EOT

  tags = merge(local.network_common_tags, {
    class = "unused"
  })
}