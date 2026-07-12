# Observability Lab

A central repository for infrastructure automation used to deploy, configure, and manage observability platforms across different environments.

The repository is designed to support multiple automation frameworks such as:

* CINC/Chef
* Ansible
* Terraform
* Custom automation scripts

and multiple observability solutions such as:

* Datadog
* Dynatrace
* OpenTelemetry
* Future monitoring and telemetry platforms

---

# Repository Structure

```text
observability-lab/
│
├── .github/
│   └── workflows/
│       │
│       ├── cinc/
│       │   └── cinc-datadog-agent.yml
│       │
│       ├── ansible/
│       │   └── ansible-validation.yml
│       │
│       ├── terraform/
│       │   └── terraform-validation.yml
│       │
│       └── reusable/
│           └── (future shared workflows)
│
│
├── automation/
│   │
│   ├── cinc/
│   │   │
│   │   └── datadog_custom/
│   │       │
│   │       ├── Policyfile.rb
│   │       ├── Policyfile.lock.json
│   │       ├── Gemfile
│   │       ├── Gemfile.lock
│   │       │
│   │       ├── client.rb
│   │       │
│   │       ├── scripts/
│   │       │   ├── bootstrap-ubuntu.sh
│   │       │   ├── bootstrap-rhel.sh
│   │       │   └── utility scripts
│   │       │
│   │       ├── docs/
│   │       │
│   │       └── datadog-agent/
│   │           ├── metadata.rb
│   │           ├── recipes/
│   │           ├── attributes/
│   │           ├── templates/
│   │           ├── libraries/
│   │           └── spec/
│   │
│   │
│   ├── ansible/
│   │   │
│   │   ├── datadog/
│   │   ├── dynatrace/
│   │   └── otel/
│   │
│   │
│   ├── terraform/
│   │   │
│   │   ├── datadog/
│   │   ├── dynatrace/
│   │   └── observability-infrastructure/
│   │
│   │
│   └── scripts/
│
│
├── docs/
│   ├── architecture/
│   ├── deployment-guides/
│   └── troubleshooting/
│
│
├── examples/
│
├── CHANGELOG.md
└── README.md
```

---

# Directory Responsibilities

## `.github/workflows`

Contains CI/CD automation.

Workflows are organised by automation technology rather than by observability product.

Example:

```
.github/workflows/cinc/
```

contains CINC/Chef related workflows.

Workflows use path filtering so only relevant automation runs.

Example:

```yaml
paths:
  - "automation/cinc/datadog_custom/**"
```

A change to the Datadog CINC automation triggers only the required workflow.

---

# CINC Automation

Location:

```
automation/cinc/
```

Each observability platform has an independent CINC project.

Example:

```
automation/cinc/datadog_custom/
```

## Project Files

### Policyfile.rb

Defines the cookbook composition and node policy.

Example responsibilities:

* Cookbook selection
* Cookbook versions
* Run list definition
* Dependency resolution

### Gemfile

Defines Ruby dependencies required for:

* Chef
* CINC
* Cookstyle
* ChefSpec
* Test Kitchen

---

# Cookbook Structure

Cookbooks contain only Chef automation logic.

Example:

```
datadog-agent/
├── recipes/
├── attributes/
├── templates/
├── libraries/
└── metadata.rb
```

Responsibilities:

* Installing packages
* Managing configuration
* Creating services
* Managing system resources

---

# Scripts

Location:

```
scripts/
```

Contains helper scripts used by developers and automation.

Examples:

* Environment bootstrap
* Dependency installation
* Local development setup
* Utility commands

OS-specific scripts should remain separate:

```
scripts/
├── bootstrap-ubuntu.sh
├── bootstrap-rhel.sh
└── bootstrap-amazon-linux.sh
```

---

# Ansible Automation

Location:

```
automation/ansible/
```

Contains Ansible roles and playbooks.

Example:

```
automation/ansible/datadog/
automation/ansible/dynatrace/
automation/ansible/otel/
```

Each platform maintains its own lifecycle and workflow.

---

# Terraform Automation

Location:

```
automation/terraform/
```

Used for infrastructure and cloud resource automation.

Examples:

* Monitoring infrastructure
* Cloud integrations
* Required platform resources

---

# CI/CD Design Principles

## Path-based execution

Workflows should run only when relevant code changes.

Example:

Datadog CINC workflow:

```yaml
paths:
  - "automation/cinc/datadog_custom/**"
```

Benefits:

* Faster pipelines
* Reduced unnecessary execution
* Clear ownership

---

## Separation of Responsibilities

GitHub Actions:

* Runs validation
* Executes tests
* Performs linting
* Publishes results

Automation frameworks:

* Configure systems
* Install agents
* Manage services
* Apply infrastructure changes

---

# Future Expansion

The repository is designed to support:

```
automation/
├── cinc/
│   ├── datadog_custom/
│   └── dynatrace_custom/
│
├── ansible/
│   ├── datadog/
│   ├── dynatrace/
│   └── otel/
│
└── terraform/
```

New automation technologies and observability platforms can be added without changing existing workflows.

---

# Development Workflow

Typical contribution flow:

1. Create or update automation code
2. Commit changes
3. GitHub Actions detects affected paths
4. Relevant validation workflow executes
5. Changes are reviewed and merged

---

# Project Goal

Provide a maintainable, scalable automation platform for deploying and managing observability tooling across different environments using infrastructure-as-code practices.

```
```

