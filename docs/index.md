---
repository: "https://github.com/turbot/steampipe-mod-digitalocean-thrifty"
---

# DigitalOcean Thrifty Mod

Be Thrifty on DigitalOcean! This mod checks for unused resources and opportunities to optimize your spend on DigitalOcean.

<TO-DO>
<TO-DO>
<TO-DO>

## References

[DigitalOcean](https://www.digitalocean.com) provides on-demand cloud computing platforms and APIs to authenticated customers on a metered pay-as-you-go basis.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/digitalocean_thrifty/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/digitalocean_thrifty/queries)**

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
``

Install the DigitalOcean plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install digitalocean
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-digitalocean-thrifty.git
cd steampipe-mod-digitalocean-thrifty
```

### Usage

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at https://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command:

Run all benchmarks:

```sh
steampipe check all
```

Run a single benchmark:

```sh
steampipe check benchmark.droplet
```

Run a specific control:

```sh
steampipe check control.control.droplet_long_running
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

This mod uses the credentials configured in the [Steampipe DigitalOcean plugin](https://hub.steampipe.io/plugins/turbot/digitalocean).

### Configuration

No extra configuration is required.

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [DigitalOcean Thrifty Mod](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/labels/help%20wanted)