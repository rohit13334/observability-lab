# Building a Datadog Agent Cookbook from Scratch using Cinc

## Project Overview

This project demonstrates how to build a production-ready **Cinc (Chef Infra Client Community Edition)** cookbook to deploy and configure the **Datadog Agent** on Ubuntu Linux.

Unlike the official Datadog cookbook, this project is built **from scratch** to understand every component involved in configuration management.

The objective is to learn:

- Cookbook development
- Chef/Cinc Resources
- Attributes
- Templates
- Notifications
- Idempotency
- Berkshelf
- Test Kitchen
- AWS Deployment
- Infrastructure as Code (IaC)

---

# Objectives

The cookbook will:

- Install the Datadog Repository
- Install the Datadog Agent
- Generate datadog.yaml dynamically
- Enable and start the Datadog service
- Support future integrations
- Be reusable across multiple Ubuntu servers

---

# High Level Architecture

```
                    GitHub Repository
                           │
                           │
                           ▼
                  Cinc Workstation
                (Cookbook Development)
                           │
                           │
                   Berkshelf Vendor
                           │
                           ▼
                 Custom Cookbook
                 datadog-agent
                           │
                           ▼
                Cinc Client (Local Mode)
                           │
                           ▼
                   Ubuntu EC2 Instance
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
         ▼                 ▼                 ▼
  Repository Setup   Install Agent   Configure Agent
         │                 │                 │
         └─────────────────┼─────────────────┘
                           ▼
                  Enable Datadog Service
                           │
                           ▼
                  Datadog Cloud Platform
```

---

# Project Directory Structure

```
automation/
└── cinc/
    └── datadog-custom/
        │
        ├── README.md
        ├── client.rb
        ├── Berksfile
        ├── deploy.sh
        │
        ├── cookbooks/
        │      ├── apt/
        │      ├── yum/
        │      └── datadog/
        │
        └── datadog-agent/
            ├── metadata.rb
            ├── Policyfile.rb
            ├── attributes/
            │      └── default.rb
            ├── recipes/
            │      ├── default.rb
            │      ├── repository.rb
            │      ├── install.rb
            │      ├── configure.rb
            │      └── service.rb
            ├── templates/
            │      └── default/
            │             └── datadog.yaml.erb
            ├── files/
            └── test/
```

---

# Cookbook Architecture

```
                default.rb
                     │
                     │
      ┌──────────────┼───────────────┐
      │              │               │
      ▼              ▼               ▼
repository.rb   install.rb    configure.rb
                                      │
                                      ▼
                           datadog.yaml.erb
                                      │
                                      ▼
                               service.rb
```

---

# Deployment Workflow

```
Developer

    │

    ▼

Git Commit

    │

    ▼

GitHub

    │

    ▼

Clone Repository

    │

    ▼

Run deploy.sh

    │

    ▼

Cinc Client

    │

    ▼

Repository

    │

    ▼

Install Package

    │

    ▼

Configure Agent

    │

    ▼

Enable Service

    │

    ▼

Datadog Cloud
```

---

# Component Responsibilities

## repository.rb

Responsible for

- Installing GPG Keys
- Adding Datadog Repository
- Running apt update

---

## install.rb

Responsible for

- Installing datadog-agent package
- Package upgrades
- Version pinning

---

## configure.rb

Responsible for

- Generating

```
/etc/datadog-agent/datadog.yaml
```

using

```
templates/default/datadog.yaml.erb
```

---

## service.rb

Responsible for

- Enable Service
- Start Service
- Restart when configuration changes

---

# Configuration Flow

```
Attributes

default.rb

      │

      ▼

ERB Template

datadog.yaml.erb

      │

      ▼

Chef Template Resource

      │

      ▼

/etc/datadog-agent/datadog.yaml
```

---

# Datadog Agent Installation Flow

```
repository.rb

        │

        ▼

Install GPG Key

        │

        ▼

Add Datadog Repository

        │

        ▼

apt update

        │

        ▼

install.rb

        │

        ▼

apt install datadog-agent

        │

        ▼

configure.rb

        │

        ▼

Generate datadog.yaml

        │

        ▼

service.rb

        │

        ▼

systemctl enable datadog-agent

        │

        ▼

systemctl start datadog-agent
```

---

# Learning Roadmap

## Phase 1

- Repository Setup

## Phase 2

- Package Installation

## Phase 3

- Configuration Management

## Phase 4

- Services

## Phase 5

- Notifications

## Phase 6

- Templates

## Phase 7

- Attributes

## Phase 8

- Testing

## Phase 9

- AWS Deployment

## Phase 10

- CI/CD

---

# Technologies Used

- Ubuntu 22.04
- AWS EC2
- Cinc Client
- Cinc Workstation
- Ruby
- Chef Resources
- Berkshelf
- Test Kitchen
- InSpec
- Git
- GitHub
- Datadog

---

# Future Enhancements

- Support Ubuntu 24.04
- Support Amazon Linux
- Support RHEL
- Support Rocky Linux
- Support Proxy
- DogStatsD
- Log Collection
- Process Monitoring
- APM
- Security Agent
- Kubernetes
- Docker
- NGINX Integration
- MySQL Integration
- Apache Integration

---

# Expected Outcome

At the completion of this project, the cookbook will be capable of:

- Installing the Datadog Agent
- Configuring the Agent
- Managing upgrades
- Managing configuration changes
- Automatically restarting services when required
- Deploying consistently across multiple Ubuntu servers

while following Infrastructure as Code (IaC) and configuration management best practices.

---
