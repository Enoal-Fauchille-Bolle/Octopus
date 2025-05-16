# Octopus

## Table of Contents

- [Overview](#overview)
- [Goals](#goals)
- [Features](#features)
- [Installation & Usage](#installation--usage)
  - [Prerequisites](#1-prerequisites)
  - [Inventory structure](#2-inventory-structure)
  - [Directory Layout](#3-directory-layout)
  - [Running the Playbook](#4-running-the-playbook)
  - [Accessing Services](#5-accessing-services)
- [Contributing](#contributing)
- [Contributors](#contributors)
- [License](#license)

## Overview

This project automates the deployment of a three‑tier poll application using Ansible on five Debian 12 virtual machines. The stack consists of:

* **Flask** web client ("poll") to accept votes and enqueue them in Redis
* **Redis** as a queue
* **Java** worker to consume votes and write them into PostgreSQL
* **PostgreSQL 16** to store final tallies
* **Node.js** web client ("result") to display poll results

## Goals

* **Idempotent** configuration management: rerunning the playbook yields minimal changes.
* **Separation of concerns** via Ansible roles: `base`, `redis`, `postgresql`, `poll`, `worker`, `result`.
* **Systemd‑managed services** with environment‑variable configuration for 12‑factor compliance.
* **Security best practices**: avoid clear‑text credentials in repo; option for Redis authentication as a bonus.

## Features

* **Base role** installs Git, common utilities, and configures the Debian 12 host.
* **Redis role** installs and configures Redis, with optional password protection.
* **PostgreSQL role** installs v16, sets up a `paul` database user (password vaulted), and creates the `paul` database schema.
* **Poll role** deploys the Flask app, installs Python dependencies, and configures a `poll.service`.
* **Worker role** deploys the Java consumer, builds the JAR, and configures a `worker.service`.
* **Result role** deploys the Node.js app, installs npm packages, and configures a `result.service`.

## Installation & Usage

### 1. Prerequisites

   * Five Debian 12 hosts reachable by SSH as a sudo‑enabled user.
   * Ansible 2.14+ installed locally.
   * Vault password file (e.g. `/tmp/.vault_pass`) containing secrets.

### 2. Inventory structure

   The inventory file (`inventory.ini`) should define the hosts and their roles. Here's an example:

   ```ini
   [redis]
   redis-1 ansible_host=...

   [postgresql]
   postgresql-1 ansible_host=...

   [poll]
   poll-1 ansible_host=...

   [worker]
   worker-1 ansible_host=...

   [result]
   result-1 ansible_host=...
   ```

### 3. Directory Layout

   ```
   .
   ├── playbook.yml
   ├── inventory.ini
   ├── group_vars/
   │   └── all.yml
   ├── poll.tar
   ├── worker.tar
   ├── result.tar
   └── roles/
       ├── base/
       ├── redis/
       ├── postgresql/
       ├── poll/
       ├── worker/
       └── result/
   ```

### 4. Running the Playbook

   ```bash
   export ANSIBLE_VAULT_PASSWORD_FILE=/tmp/.vault_pass
   echo verySecretPassword > /tmp/.vault_pass # If not already set
   ansible-playbook -i production playbook.yml
   ```

   * On first run, all tasks execute.
   * On subsequent runs, idempotence ensures `changed = 0` for completed roles.

### 5. Accessing Services

   * **Poll UI**: (Accessible from `poll-1` host)
   * **Result UI**: (Accessible from `result-1` host)

## Contributing

1. Fork the repo and create a feature branch.
2. Write or update Ansible tasks, handlers, or role defaults.
3. Ensure idempotency and no clear‑text secrets.
4. Submit a pull request with descriptive commit messages.

## Contributors

- Evan MAHE : [GitHub/Mahe-Evan](https://github.com/Mahe-Evan)
- Enoal FAUCHILLE-BOLLE : [GitHub/Enoal-Fauchille-Bolle](https://github.com/Enoal-Fauchille-Bolle)

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for details.
