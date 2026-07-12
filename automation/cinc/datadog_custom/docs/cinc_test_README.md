# Datadog Custom Chef/Cinc Cookbook

## Project Overview

This project builds a custom Datadog Agent cookbook from scratch using **Cinc/Chef**.

The purpose is not only to install the Datadog Agent but to understand how Chef automation works internally:

* Chef resources
* Recipes
* Attributes
* Templates
* Notifications
* Package management
* Repository management
* Secrets management
* Testing with ChefSpec
* Testing with Test Kitchen
* CI/CD automation using GitHub Actions

The project intentionally does **not** use the official upstream Datadog cookbook.

The upstream cookbook exists only as a reference.

---

# Repository Structure

```
observability-lab/
└── automation/
    └── cinc/
        |
        ├── datadog_upstream/
        |       |
        |       └── Official Datadog cookbook reference
        |
        └── datadog_custom/
                |
                ├── client.rb
                |
                ├── datadog-agent/
                |       |
                |       ├── attributes/
                |       ├── recipes/
                |       ├── templates/
                |       ├── spec/
                |       ├── test/
                |       ├── kitchen.yml
                |       ├── metadata.rb
                |       └── Gemfile
                |
                ├── scripts/
                |
                └── docs/
```

---

# Cookbook Architecture

The cookbook follows this flow:

```
default.rb

    |
    |
    +---- secrets.rb
    |
    +---- repository.rb
    |
    +---- install.rb
    |
    +---- configure.rb
    |
    +---- service.rb
```

Removal:

```
uninstall.rb

    |
    +---- remove
    |
    +---- purge
```

---

# Chef Execution Flow

When Cinc runs:

```
cinc-client

      |
      |
      v

compile phase

      |
      |
      v

recipes loaded

      |
      |
      v

resources collected

      |
      |
      v

converge phase

      |
      |
      v

system changes applied
```

---

# Implemented Components

## 1. Package Installation

Resource:

```ruby
package
```

Purpose:

Install software using the operating system package manager.

Examples:

Ubuntu:

```
apt
```

RedHat:

```
yum/dnf
```

Windows:

```
MSI packages
```

Current usage:

```ruby
package 'datadog-agent' do
  action :install
end
```

---

# 2. Datadog Repository Configuration

File:

```
recipes/repository.rb
```

Flow:

```
Install prerequisites

        |
        v

curl
gnupg

        |
        v

Download Datadog signing key

        |
        v

Convert ASCII key

        |
        v

Create APT keyring

        |
        v

Create repository file

        |
        v

apt update
```

Repository file:

```
/etc/apt/sources.list.d/datadog.list
```

Example:

```
deb [signed-by=/usr/share/keyrings/datadog-archive-keyring.gpg] https://apt.datadoghq.com stable 7
```

---

# 3. Configuration Management

Resource:

```ruby
template
```

Creates:

```
/etc/datadog-agent/datadog.yaml
```

Template:

```
templates/default/datadog.yaml.erb
```

Variables come from:

```
attributes/default.rb
```

Example:

```ruby
node['datadog']['api_key']
```

---

# 4. Service Management

Resource:

```ruby
service
```

Controls:

```
start
stop
restart
enable
status
```

Example:

```ruby
service 'datadog-agent' do
  action [:enable, :start]
end
```

Chef automatically knows how to manage:

* systemd
* init scripts
* service managers

---

# 5. AWS Secrets Manager Integration

Current design:

```
EC2 Instance

      |
      |
IAM Role

      |
      |
AWS Secrets Manager

      |
      |
Chef execute resource

      |
      |
Ruby JSON parser

      |
      |
node attributes
```

Secret:

```
datadog/api_key
```

Command tested:

```bash
aws secretsmanager get-secret-value \
 --secret-id datadog/api_key \
 --query SecretString \
 --output text
```

Future improvement:

Replace AWS CLI with:

```
aws-sdk-ruby
```

---

# Local Mode Execution

Chef can run without Chef Server.

Command:

```bash
sudo cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent::default]'
```

Explanation:

| Option | Meaning              |
| ------ | -------------------- |
| -z     | local mode           |
| -c     | client configuration |
| -r     | run list             |

---

# Chef Client Commands

## Run cookbook

```bash
cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent::default]'
```

---

## Run specific recipe

Example:

```bash
cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent::repository]'
```

Useful for debugging.

---

## Show Chef version

```bash
cinc-client --version
```

---

## Debug logging

```bash
cinc-client \
-z \
-l debug
```

Log levels:

```
fatal
error
warn
info
debug
```

---

# Chef Resources Used

## package

Installs software.

Example:

```ruby
package 'curl'
```

---

## directory

Creates directories.

Example:

```ruby
directory '/usr/share/keyrings'
```

---

## remote_file

Downloads files.

Example:

```ruby
remote_file '/tmp/datadog.key'
```

---

## execute

Runs shell commands.

Example:

```ruby
execute 'gpg dearmor'
```

Use carefully.

Prefer native Chef resources when possible.

---

## template

Creates configuration files.

Uses:

```
ERB templates
```

---

## service

Manages services.

---

## ruby_block

Runs Ruby code during Chef execution.

Example:

Parsing JSON secrets.

---

# Notifications

Chef resources can notify each other.

Example:

```
template changes

        |
        |
        v

restart service
```

Example:

```ruby
notifies :restart,
'service[datadog-agent]',
:delayed
```

Delayed means:

Restart happens at the end of the Chef run.

---

# ChefSpec Testing

ChefSpec is a unit testing framework.

It does NOT modify the system.

It checks:

"Would Chef create this resource?"

Example:

```
Recipe

   |
   |
   v

ChefSpec

   |
   |
   v

Expected resources?
```

Example:

```ruby
expect(chef_run)
.to install_package('datadog-agent')
```

Useful commands:

Run all tests:

```bash
bundle exec rspec
```

Run one test:

```bash
bundle exec rspec spec/unit/recipes/install_spec.rb
```

---

# Test Kitchen

Test Kitchen creates real test machines.

Unlike ChefSpec:

ChefSpec:

```
simulation
```

Kitchen:

```
real container/VM
```

Flow:

```
Kitchen

 |
 |
 v

Create machine

 |
 |
 v

Install Chef

 |
 |
 v

Run cookbook

 |
 |
 v

Verify state
```

---

# Kitchen Commands

## List instances

```bash
bundle exec kitchen list
```

---

## Create machines

```bash
bundle exec kitchen create
```

Creates test environments.

---

## Converge cookbook

```bash
bundle exec kitchen converge
```

Runs Chef.

---

## Verify

```bash
bundle exec kitchen verify
```

Runs InSpec tests.

---

## Destroy

```bash
bundle exec kitchen destroy
```

Removes test machines.

---

## Complete lifecycle

```bash
bundle exec kitchen test
```

Equivalent:

```
destroy
create
converge
verify
destroy
```

---

# Kitchen Drivers

Kitchen supports different execution targets.

## Docker

Best for:

* fast testing
* CI/CD
* Linux testing

Configuration:

```yaml
driver:
  name: docker
```

Advantages:

* fast
* lightweight
* GitHub Actions friendly

---

## Vagrant

Uses local virtual machines.

Configuration:

```yaml
driver:
  name: vagrant
```

Advantages:

* full VM
* closer to production

Disadvantages:

* slower
* requires VirtualBox/libvirt

---

## AWS EC2

Can test real cloud machines.

Driver:

```
kitchen-ec2
```

Example:

```
Kitchen

 |
 |
 v

AWS EC2 Instance

 |
 |
 v

Chef converge
```

Useful for:

* AMI validation
* cloud automation testing

---

# Supported Platforms

Kitchen examples:

```yaml
platforms:

- ubuntu-24.04
- amazonlinux-2023
- almalinux-9
```

For Datadog cookbook:

Current support:

```
Ubuntu/Debian
```

Future:

```
Ubuntu
RedHat
Amazon Linux
Windows
```

---

# GitHub Actions Future Architecture

Planned:

```
Developer

 |
 git push

 |
 v

GitHub Actions

 |
 +---- Cookstyle
 |
 +---- ChefSpec
 |
 +---- Kitchen Docker
 |
 +---- Security scans

 |
 v

Approved cookbook
```

---

# Future Improvements

## Testing

Add:

* ChefSpec coverage
* Kitchen Docker tests
* InSpec controls

## Secrets

Replace:

```
AWS CLI
```

with:

```
AWS SDK Ruby
```

## Multi-platform Support

Add:

```
recipes/platform_linux.rb

recipes/platform_windows.rb
```

Support:

```
Ubuntu
RedHat
Amazon Linux
Windows
```

---

# Useful Development Commands

Check files:

```bash
tree
```

---

Check Ruby:

```bash
ruby --version
```

---

Check gems:

```bash
bundle list
```

---

Install dependencies:

```bash
bundle install
```

---

Check cookbook style:

```bash
bundle exec cookstyle
```

---

Generate cookbook:

```bash
cinc generate cookbook cookbook-name
```

---

# Current Status

Completed:

* Custom cookbook created
* Repository management
* GPG key handling
* Datadog repository setup
* Package installation
* Service management
* Configuration templates
* AWS Secrets Manager integration
* ChefSpec introduction
* Kitchen framework setup

Next:

* Upgrade Ruby development environment
* Move to Chef 19 testing stack
* Build Kitchen Docker tests
* Add GitHub Actions pipeline
* Add multi-platform support
* Create production documentation

