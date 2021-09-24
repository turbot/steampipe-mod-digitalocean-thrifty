---
repository: "https://github.com/turbot/steampipe-mod-digitalocean-thrifty"
---

# DigitalOcean Thrifty Mod

Be Thrifty on DigitalOcean! This mod checks for unused resources and opportunities to optimize your spend on DigitalOcean.

## References

[DigitalOcean](https://www.digitalocean.com) provides on-demand cloud computing platforms and APIs to authenticated customers on a metered pay-as-you-go basis.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/digitalocean_thrifty/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/digitalocean_thrifty/queries)**

## Get started

Install the DigitalOcean plugin with [Steampipe](https://steampipe.io):

```shell
steampipe plugin install digitalocean
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-digitalocean-thrifty.git
cd steampipe-mod-digitalocean-thrifty
```

Run all benchmarks:

```shell
steampipe check all
```

Run a specific control:

```shell
steampipe check control.droplet_long_running
```

### Credentials

This mod uses the credentials configured in the [Steampipe DigitalOcean plugin](https://hub.steampipe.io/plugins/turbot/digitalocean).

### Configuration

No extra configuration is required.

## Get involved

- Contribute: [Help wanted issues](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/labels/help%20wanted)
- Community: [Slack channel](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)
