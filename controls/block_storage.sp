locals {
  block_storage_common_tags = merge(local.thrifty_common_tags, {
    service = "volume"
  })
}

benchmark "volume" {
  title         = "Block Storage Volumes Checks"
  description   = "Thrifty developers ensure delete unused block storage volumes resources."
  documentation = file("./controls/docs/network.md")
  tags          = local.volume_common_tags
  children = [
    control.block_storage_volume_large,
    block_storage_volume_attached_stopped_instance,
    block_storage_volume_unattached
  ]
}

control "block_storage_volume_large" {
  title       = "Large block storage volumes are unusual, expensive and should be reviewed."
  description = "Block storage volumes with over 100 GB should be resized if too large"
  severity    = "low"

  sql = <<-EOT
    select
      urn as resource,
      case
        when size_gigabytes <= 100 then 'ok'
        else 'alarm'
      end as status,
      id || ' is ' || size_gigabytes || 'GB.' as reason,
      region_name as region
    from
      digitalocean_volume
  EOT

  tags = merge(local.block_storage_common_tags, {
    class = "unused"
  })
}

control "block_storage_volume_attached_stopped_instance" {
  title       = "Storage block volumes attached to stopped droplet should be reviewed"
  description = "Droplets that are stopped may no longer need any volumes attached."
  severity    = "low"

  sql = <<-EOT
    select
      v.urn as resource,
      case
        when d.id is null then 'alarm'
        when d.status <> 'active' then 'alarm'
        else 'ok'
      end as status,
      case
        when d.id is null then v.title || ' unattached.'
        when d.status <> 'active' then v.title || ' associated to stopped droplet.'
        else v.title || ' in use.'
      end as reason,
      v.region_name
    from
      digitalocean_volume as v
      left join digitalocean_droplet as d on v.droplet_ids @> ('['||d.id||']'):: jsonb
  EOT

  tags = merge(local.block_storage_common_tags, {
    class = "unused"
  })
}

control "block_storage_volume_unattached" {
  title       = "Storage block volumes not attached any droplets should be reviewed"
  description = "Volumes that are unattached may no longer need."
  severity    = "low"

  sql = <<-EOT
    select
      urn as resource,
      case
        when jsonb_array_length(droplet_ids) < 1 then 'alarm'
        else 'ok'
      end as status,
      case
        when jsonb_array_length(droplet_ids) < 1 then title || ' not associated.'
        else title || ' associated to droplets ' || droplet_ids || '.'
      end as reason,
      region_name
    from
      digitalocean_volume
  EOT

  tags = merge(local.block_storage_common_tags, {
    class = "unused"
  })
}