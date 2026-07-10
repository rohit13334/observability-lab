# Datadog Agent Deployment Using Cinc Client

## Overview

This project automates the installation and configuration of the Datadog Agent on Ubuntu Linux servers using Cinc Client.

The solution uses:

* **Cinc Client** - Chef-compatible configuration management client
* **Custom cookbook** - `datadog-agent`
* **Berkshelf** - Dependency management for Chef cookbooks
* **Local mode execution** - No Chef Server required

---

# Architecture

```
                 Git Repository
                       |
                       |
                       v
          deploy_datadog_agent.sh
                       |
                       |
        +--------------+--------------+
        |                             |
        v                             v
 Install Cinc                  Install Dependencies
                                      |
                                      |
                                      v
                                Berksfile
                                      |
                                      |
              +-----------------------+----------------+
              |                       |                |
              v                       v                v
          datadog                 apt              yum
          cookbook              cookbook        cookbook


                       |
                       |
                       v

              Cinc Client Local Mode

                       |
                       |

              datadog-agent cookbook

                       |
                       |

              Datadog Agent Service

                       |
                       |

              Datadog Cloud Platform
```

---

# Repository Structure

```
datadog/
|
├── deploy_datadog_agent.sh
├── Berksfile
├── Berksfile.lock
├── README.md
|
└── datadog-agent/
    |
    ├── metadata.rb
    ├── recipes/
    |   └── default.rb
    ├── attributes/
    ├── compliance/
    └── test/
```

---

# How It Works

The deployment process:

1. Clone the repository
2. Run the deployment script
3. Script installs Cinc Client
4. Script downloads cookbook dependencies using Berkshelf
5. Cinc executes the custom cookbook
6. Datadog Agent is installed and started

---

# Prerequisites

Supported platform:

```
Ubuntu 22.04 LTS
```

Required:

* Internet access
* sudo privileges
* Git installed (script installs if missing)

---

# Deploy Datadog Agent

Clone repository:

```bash
git clone <repository-url>
```

Navigate:

```bash
cd automation/cinc/datadog
```

Make script executable:

```bash
chmod +x deploy_datadog_agent.sh
```

Run deployment:

```bash
sudo ./deploy_datadog_agent.sh
```

---

# Cookbook Structure

Custom cookbook:

```
datadog-agent
|
├── metadata.rb
|
└── recipes
    |
    └── default.rb
```

Recipe execution:

```
recipe[datadog-agent::default]
```

---

# Dependency Management

Dependencies are defined in:

```
Berksfile
```

Example:

```ruby
source 'https://supermarket.chef.io'

cookbook 'datadog'
cookbook 'apt'
cookbook 'yum'
```

Dependencies are downloaded during deployment:

```
berks vendor cookbooks
```

The downloaded cookbooks are temporary and are not stored in Git.

---

# Cinc Configuration

The deployment script creates:

```
client.rb
```

with:

```ruby
cookbook_path [
  "/path/to/datadog",
  "/path/to/datadog/cookbooks"
]
```

---

# Manual Execution

If required, run manually:

```bash
sudo cinc-client \
  -z \
  -c client.rb \
  -r 'recipe[datadog-agent::default]'
```

---

# Validation

Check Datadog service:

```bash
systemctl status datadog-agent
```

Check agent health:

```bash
datadog-agent status
```

View logs:

```bash
journalctl -u datadog-agent
```

---

# Troubleshooting

## Missing Cookbook

Example:

```
No such cookbook: datadog
```

Solution:

Run:

```bash
berks vendor cookbooks
```

---

## Empty Run List

Example:

```
Node has an empty run list
```

Cause:

Cinc was started without a recipe.

Solution:

Run:

```bash
-r 'recipe[datadog-agent::default]'
```

---

## Cookbook Not Found

Example:

```
No such cookbook: datadog-agent
```

Check:

```bash
cat client.rb
```

Verify the cookbook path includes the parent directory containing:

```
datadog-agent/metadata.rb
```

---

# Git Repository Guidelines

Do not commit:

```
cookbooks/
local-mode-cache/
nodes/
cinc_guid
*.pem
```

These are generated during execution.

Commit:

```
deploy_datadog_agent.sh
Berksfile
Berksfile.lock
datadog-agent/
README.md
```

---

# Future Improvements

Possible enhancements:

* Store Datadog API key using secrets management
* Configure tags automatically
* Enable logs collection
* Enable APM
* Add CI/CD pipeline
* Add multiple environment support

---

# Summary

Deployment requires only:

```bash
git clone <repository>
cd automation/cinc/datadog
sudo ./deploy_datadog_agent.sh
```

The server will automatically:

* Install Cinc
* Download cookbook dependencies
* Execute the cookbook
* Install Datadog Agent
* Start the monitoring service

