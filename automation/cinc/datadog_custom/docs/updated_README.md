# Custom Datadog Agent Cookbook using Cinc/Chef

## Overview

This project demonstrates building a **custom Datadog Agent deployment cookbook from scratch using Cinc/Chef**.

Instead of using the upstream Datadog cookbook, this implementation recreates the required functionality:

* Configure Datadog APT repository
* Install Datadog Agent
* Retrieve API key securely from AWS Secrets Manager
* Generate Datadog configuration
* Manage Datadog service lifecycle
* Remove or purge Datadog Agent

The objective of this project is to understand Chef cookbook architecture, resources, recipes, attributes, templates, notifications, and infrastructure automation practices.

---

# Architecture

## High-Level Flow

```text
                         AWS Cloud
                            |
                            |
                  AWS Secrets Manager
                            |
                            |
                 datadog/api_key secret
                            |
                            |
                    EC2 Instance
                            |
                            |
                     Cinc Client
                            |
                            |
              datadog-agent Cookbook
                            |
        +-------------------+-------------------+
        |                   |                   |
        |                   |                   |
   secrets.rb        repository.rb        install.rb
        |                   |                   |
        |                   |                   |
 Retrieve API       Configure APT       Install Agent
 Key from AWS       Repository          Package
        |
        |
 configure.rb
        |
        |
 Generate /etc/datadog-agent/datadog.yaml
        |
        |
 service.rb
        |
        |
 systemd
        |
        |
 Datadog Agent Running
```

---

# Cookbook Structure

```
datadog-agent/
|
├── attributes/
│   └── default.rb
|
├── recipes/
│   |
│   ├── default.rb
│   ├── secrets.rb
│   ├── repository.rb
│   ├── install.rb
│   ├── configure.rb
│   ├── service.rb
│   └── uninstall.rb
|
├── templates/
│   └── default/
│       ├── datadog.yaml.erb
│       └── datadog.list.erb
|
├── metadata.rb
└── README.md
```

---

# Recipe Execution Flow

The default recipe controls the execution order.

```
default.rb

     |
     |
     +---- secrets.rb
     |
     |
     +---- repository.rb
     |
     |
     +---- install.rb
     |
     |
     +---- configure.rb
     |
     |
     +---- service.rb

```

Chef recipes are not automatically hierarchical.

Example:

```
service.rb
    |
    include_recipe configure.rb
            |
            include_recipe install.rb
```

Only recipes explicitly included using:

```ruby
include_recipe
```

are executed.

---

# AWS Secrets Manager Integration

## Purpose

The Datadog API key is not stored inside:

* cookbook code
* attributes
* configuration files
* Git repository

The API key is stored in:

```
AWS Secrets Manager
```

Secret:

```
datadog/api_key
```

---

## Authentication Flow

```
EC2 Instance

     |
     |
IAM Instance Role

     |
     |
AWS STS

     |
     |
Secrets Manager API

     |
     |
Datadog API Key
```

No AWS access keys are stored on the server.

---

# secrets.rb Flow

Current implementation:

```
Chef
 |
 |
execute resource
 |
 |
AWS CLI
 |
 |
Secrets Manager
 |
 |
/tmp/datadog-secret.json
 |
 |
ruby_block
 |
 |
node['datadog']['api_key']
```

Future improvement:

Replace AWS CLI with:

```
aws-sdk-secretsmanager Ruby Gem
```

to avoid writing secrets to disk.

---

# Repository Management

The cookbook manages the Datadog APT repository manually.

## Repository Flow

```
repository.rb

     |
     |
Install packages

curl
gnupg


     |
     |
Download Datadog public key


DATADOG_APT_KEY_CURRENT.public


     |
     |
Convert key


gpg --dearmor


     |
     |
Create keyring


/usr/share/keyrings/datadog-archive-keyring.gpg


     |
     |
Create repository


/etc/apt/sources.list.d/datadog.list


     |
     |
apt update

```

---

# Important Learning: APT GPG Key Handling

The Datadog public key is downloaded as:

```
ASCII armored key
```

Example:

```
DATADOG_APT_KEY_CURRENT.public
```

APT requires:

```
Binary GPG keyring
```

Therefore conversion is required:

```bash
gpg --dearmor
```

Final key:

```
/usr/share/keyrings/datadog-archive-keyring.gpg
```

Repository:

```
deb [signed-by=/usr/share/keyrings/datadog-archive-keyring.gpg] https://apt.datadoghq.com stable 7
```

---

# Chef Resources Used

## package

Used for installing packages.

Example:

```ruby
package 'datadog-agent'
```

---

## remote_file

Downloads external resources.

Example:

```ruby
remote_file '/tmp/datadog.key'
```

---

## template

Creates configuration files from ERB templates.

Example:

```
datadog.yaml.erb
```

generates:

```
/etc/datadog-agent/datadog.yaml
```

---

## execute

Runs system commands.

Example:

```ruby
gpg --dearmor
```

---

## ruby_block

Executes Ruby code during converge.

Used for parsing JSON secrets.

---

## service

Manages systemd services.

Example:

```ruby
service 'datadog-agent'
```

Supports:

* start
* stop
* restart
* enable

---

# Notifications

Example:

```ruby
notifies :restart,
'service[datadog-agent]',
:delayed
```

Meaning:

```
Configuration changes
          |
          |
restart notification created
          |
          |
wait until converge completes
          |
          |
restart service once
```

Delayed notifications prevent unnecessary multiple restarts.

---

# Deployment Commands

## Execute cookbook

From:

```
automation/cinc/datadog_custom
```

Run:

```bash
sudo cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent::default]'
```

---

# Verification

Check service:

```bash
systemctl status datadog-agent
```

Check agent:

```bash
datadog-agent status
```

Check configuration:

```bash
cat /etc/datadog-agent/datadog.yaml
```

---

# Troubleshooting Lessons Learned

## Missing Cookbook

Error:

```
No such cookbook: datadog-agent
```

Cause:

Incorrect cookbook path.

Solution:

Ensure local mode is executed from the correct directory.

---

## Missing yum cookbook

Cause:

Upstream cookbook dependency.

Solution:

Downloaded required cookbook dependencies.

---

## AWS CLI No Credentials

Error:

```
Unable to locate credentials
```

Solution:

Attach IAM Role to EC2 instance.

---

## Empty Secret File

Error:

```
JSON::ParserError
```

Cause:

AWS command failed and redirected empty output.

Solution:

Validate command execution and use:

```bash
set -e
```

---

## Datadog Repository GPG Error

Error:

```
NO_PUBKEY
```

Cause:

ASCII key used instead of binary keyring.

Solution:

Use:

```bash
gpg --dearmor
```

---

# Future Enhancements

## Security

* Replace AWS CLI with AWS SDK
* Remove temporary secret file
* Use in-memory secret handling

## Testing

Add:

* ChefSpec
* Test Kitchen
* InSpec profiles

## CI/CD

Add:

* GitHub Actions
* cookbook linting
* automated testing

## Configuration

Move hardcoded values into attributes:

```
datadog site
AWS region
secret name
agent version
repository URL
```

---

# Project Goal

The final objective is a reusable production-style Cinc/Chef cookbook capable of deploying Datadog Agent securely across AWS environments while demonstrating:

* Chef architecture
* Infrastructure as Code
* AWS IAM integration
* Secret management
* Linux package management
* Service automation
* Configuration management

```
```

