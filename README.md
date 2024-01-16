# DigitalOcean Thrifty Mod for Steampipe

Are you a Thrifty DigitalOcean dev? This Steampipe mod checks your DigitalOcean account(s) for unused and under-utilized resources.

Run checks in a dashboard:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-digitalocean-thrifty/main/docs/digitalocean_thrifty_dashboard.png)

Includes checks for:

- Underused **Kubernetes** Clusters
- Unused, underused and oversized **Droplets** and **Snapshots**
- Unused, underused and oversized **Database** Clusters
- Unused, underused and oversized **Block Storage Volumes**
- **Network Checks**
- [#TODO List](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

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
window at http://localhost:9194. From here, you can run benchmarks by
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
steampipe check control.droplet_long_running
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

This mod uses the credentials configured in the [Steampipe DigitalOcean plugin](https://hub.steampipe.io/plugins/turbot/digitalocean).

### Configuration

Several benchmarks have [input variables](https://steampipe.io/docs/using-steampipe/mod-variables) that can be configured to better match your environment and requirements. Each variable has a default defined in its source file, e.g., `controls/droplet.sp`, but these can be overwritten in several ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file
- Pass in a value on the command line:

  ```shell
  steampipe check benchmark.droplet --var=droplet_snapshot_age_max_days=90
  ```

- Set an environment variable:

  ```shell
  SP_VAR_droplet_snapshot_age_max_days=90 steampipe check control.droplet_snapshot_age_90
  ```

  - Note: When using environment variables, if the variable is defined in `steampipe.spvars` or passed in through the command line, either of those will take precedence over the environment variable value. For more information on variable definition precedence, please see the link below.

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://steampipe.io/docs/using-steampipe/mod-variables#passing-input-variables).

### Common and Tag Dimensions

The benchmark queries use common properties (like `connection_name` and `region`) and tags that are defined in the form of a default list of strings in the `mod.sp` file. These properties can be overwritten in several ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file
- Pass in a value on the command line:

  ```shell
  steampipe check benchmark.droplet --var 'common_dimensions=["connection_name", "region"]'
  ```

  ```shell
  steampipe check benchmark.droplet --var 'tag_dimensions=["Environment", "Owner"]'
  ```

- Set an environment variable:

  ```shell
  SP_VAR_common_dimensions='["connection_name", "region"]' steampipe check control.droplet_long_running
  ```

  ```shell
  SP_VAR_tag_dimensions='["Environment", "Owner"]' steampipe check control.droplet_long_running
  ```

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join #steampipe on Slack →](https://turbot.com/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [DigitalOcean Thrifty Mod](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/labels/help%20wanted)
