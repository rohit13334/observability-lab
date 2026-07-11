# Custom Datadog Agent Deployment Using Cinc (Chef Community Build)

## Overview

This project demonstrates how to build a custom Cinc cookbook from scratch to deploy and configure the Datadog Agent on Ubuntu Linux servers.

The goal is to understand the core configuration management concepts used by enterprise Chef/Cinc environments:

* Cookbooks
* Recipes
* Attributes
* Templates
* Resources
* Notifications
* Idempotency
* Local mode execution

Instead of using the upstream Datadog cookbook, this project recreates the required functionality using a custom cookbook.

---

# Architecture Overview

## High-Level Deployment Flow

```
                 Developer / Git Repository

                          |
                          |
                          v

                    Cinc Cookbook

                          |
                          |
                          v

              datadog-agent::default

                          |
        +-----------------+----------------+
        |                 |                |
        v                 v                v

 repository.rb       install.rb       service.rb

        |                 |                |
        |                 |                |
        v                 v                v

 Datadog APT        Install Package    systemd Service
 Repository         datadog-agent      Management

        |
        |
        v

 configure.rb

        |
        |
        v

 /etc/datadog-agent/datadog.yaml

        |
        |
        v

 Datadog Agent Running
```

---

# Project Directory Structure

```
datadog_custom/

├── client.rb
│
├── datadog-agent/
│
│   ├── metadata.rb
│   │
│   ├── attributes/
│   │   └── default.rb
│   │
│   ├── recipes/
│   │   │
│   │   ├── default.rb
│   │   ├── repository.rb
│   │   ├── install.rb
│   │   ├── configure.rb
│   │   └── service.rb
│   │
│   ├── templates/
│   │   └── default/
│   │       └── datadog.yaml.erb
│   │
│   └── README.md
```

---

# Cinc Local Mode Architecture

This project uses Cinc in local mode.

No Chef Server is required.

```
                 Ubuntu Server

                     |
                     |
                     v

                cinc-client

                     |
                     |
                     v

              client.rb

                     |
                     |
                     v

              cookbook_path

                     |
                     |
                     v

             datadog-agent cookbook

                     |
                     |
                     v

              Resources Applied
```

---

# client.rb

The client configuration tells Cinc where to find cookbooks.

Example:

```ruby
local_mode true

cookbook_path [
 "/home/cloud_user/observability-lab/automation/cinc/datadog_custom"
]
```

---

# Cookbook Execution Flow

The default recipe acts as the deployment blueprint.

```
default.rb

     |
     |
     +---- repository.rb
     |
     +---- install.rb
     |
     +---- service.rb
     |
     +---- configure.rb
```

Execution command:

```bash
cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent]'
```

---

# Recipe Details

## repository.rb

Purpose:

* Install prerequisites
* Download Datadog signing key
* Configure Datadog APT repository
* Refresh package cache

Flow:

```
repository.rb

     |
     |
     v

/etc/apt/sources.list.d/datadog.list

     |
     |
     v

apt update
```

---

## install.rb

Purpose:

Install Datadog Agent package.

Example resource:

```ruby
package node['datadog']['package_name'] do
  action :install
end
```

Equivalent Linux command:

```bash
apt install datadog-agent
```

---

## configure.rb

Purpose:

Generate:

```
/etc/datadog-agent/datadog.yaml
```

using a Chef template.

Flow:

```
attributes/default.rb

        |
        v

datadog.yaml.erb

        |
        v

/etc/datadog-agent/datadog.yaml
```

---

## service.rb

Purpose:

Manage Datadog systemd service.

Equivalent commands:

```bash
systemctl enable datadog-agent

systemctl start datadog-agent
```

Chef resource:

```ruby
service 'datadog-agent' do
  action [:enable, :start]
end
```

---

# Chef Notification Flow

Configuration changes trigger service restart.

Example:

```ruby
notifies :restart,
'service[datadog-agent]',
:delayed
```

Architecture:

```
datadog.yaml changes

          |
          |
          v

Chef notification queue

          |
          |
          v

Restart datadog-agent

          |
          |
          v

systemctl restart datadog-agent
```

---

# Immediate vs Delayed Notification

## Immediate

```
Config changed
      |
      v
Restart service immediately
      |
      v
Continue Chef run
```

Example:

```ruby
:immediately
```

---

## Delayed

```
Config changed
      |
      v
Continue Chef execution
      |
      v
Restart service at end
```

Example:

```ruby
:delayed
```

Delayed is preferred because multiple configuration changes result in one restart.

---

# Important Commands Used

## Generate Cookbook

```bash
cinc generate cookbook datadog-agent
```

---

## Check Cinc Version

```bash
cinc-client --version
```

---

## Run Cookbook in Local Mode

```bash
sudo cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent]'
```

---

## Run Specific Recipe

Repository only:

```bash
sudo cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent::repository]'
```

Install only:

```bash
sudo cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent::install]'
```

---

# Validation Commands

## Check Datadog Package

```bash
dpkg -l | grep datadog
```

---

## Check Service

```bash
systemctl status datadog-agent
```

---

## Check Configuration

```bash
cat /etc/datadog-agent/datadog.yaml
```

---

## Test Idempotency

Run twice:

```bash
sudo cinc-client \
-z \
-c client.rb \
-r 'recipe[datadog-agent]'
```

Expected second run:

```
0 resources updated
```

---

# Troubleshooting

## Error

```
No such cookbook: datadog-agent
```

Cause:

Incorrect cookbook_path.

Solution:

Ensure:

```
cookbook_path points to the parent directory
```

Example:

Correct:

```
datadog_custom/
    |
    +--- datadog-agent/
```

client.rb:

```ruby
cookbook_path [
 "/path/to/datadog_custom"
]
```

---

## Error

```
No such cookbook: apt
```

Cause:

Missing dependency cookbook.

Solution:

Download dependency using:

```bash
berks install
```

or add dependency in:

```
metadata.rb
```

---

# Current Capabilities

Implemented:

* Custom Cinc cookbook
* Datadog repository management
* Package installation
* Datadog configuration generation
* Service enable/start
* Configuration change notifications
* Local mode deployment

---

# Future Improvements

Planned enhancements:

## Security

* Remove API key from attributes
* Integrate AWS Secrets Manager
* Use encrypted secrets

## Cloud Integration

* EC2 metadata based tagging
* Environment detection
* Auto registration

## Testing

Add:

* Test Kitchen
* InSpec tests
* CI/CD pipeline

## Operations

Add:

* Logs configuration
* APM configuration
* Process monitoring
* Custom integrations

---

# Final Deployment Model

```
                 Git Repository

                       |
                       v

                 Cinc Cookbook

                       |
                       v

                Ubuntu EC2 Instance

                       |
                       v

              Datadog Agent Installed

                       |
                       v

              Datadog Monitoring Platform
```

---

# Summary

This project demonstrates how configuration management can automate the complete lifecycle of a monitoring agent:

1. Configure repository
2. Install software
3. Generate configuration
4. Manage services
5. Handle changes automatically

The same pattern can be extended to deploy almost any Linux service using Cinc/Chef.

