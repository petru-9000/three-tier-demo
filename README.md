# Simple three-tier app deployment demo with Terraform and Ansible

The [terraform](./terraform) directory contains files to deploy required infrastructure in AWS. See its own [readme](./terraform/README.md) for details.

The [ansible](./ansible) directory contains a playbook to provision the three servers and deploy the app together with a Vagrantfile to create infrastructure for tests, and an appropriate inventory file. See its own [readme](./ansible/README.md) for details. Inspec tests are provided in [ansible/test](./ansible/test), see the [readme](./ansible/test/README.md) for details.

The app itself is a quick-and-dirty frontend/backend/database setup with javascript/python/postgresql. The Ansible phase of the deployment creates a database named `demo` with a table named `records` containing three rows. This is queried by the backend and the result offered on endpoint `/api/records`. The frontend presents a plain text page with data formatted as `<band> - <record>, <year>`.

### Software versions

- Terraform: 1.9.8
- Ansible: ansible-core 2.16
- Cinc Auditor: 5.22.55
- VirtualBox: 7.1.4
- Vagrant: 2.4.2
- Target OS: Ubuntu-22.04
