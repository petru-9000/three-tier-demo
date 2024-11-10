# Provision middleware and deploy three-tier app with Ansible

### Limitations:

- The servers are Ubuntu 22.04. No provision was made for other platforms (e.g. for `apt` module instead of `package`, and `apache2` instead of a scheme accomodating `httpd` as well).

### Setup

- Use a Linux machine
- Install `ansible-core`, `Vagrant`, and `VirtualBox`
- Optional: Install `sshpass` (needed by Ansible for password access to the VM's, not used here)
- Optional: Add the following to your hosts file for easy browser access (Ansible uses IP's and does not need DNS):

```
192.168.56.101 demo-web.local demo-web
192.168.56.102 demo-app.local demo-app
192.168.56.103 demo-db.local demo-db
```

### Usage

Variables are loaded from a single `vars-vagrant.yml` file, allowing various actors (e.g. `Terraform`)to supply different sets of values as needed.

The variable `demo_db_password` is encrypted via `ansible-vault`, with command: `ansible-vault encrypt_string ~/vault-pass.txt '<your-secret-password>' --name demo_db_password`. The `vault-pass.txt` file should contain a vault password (for this demo it is the string `password`) and be stored outside the repository directory (e.g. in your home directory, or any path outside this repo). This file should not reach github.

- Run `vagrant up`. This will generate the Ansible inventory file, `hosts-vagrant.yml`, raise the three required VM's, and populate their hosts files with eachother's IP's and names
- Run `ansible-playbook -i hosts-vagrant.yml -e vars_file=vars-vagrant.yml --vault-password-file ~/vault-pass.txt playbook.yml`

Alternatively, run the playbooks separately, starting with `middleware.yml`; the vault secret is only required by `application.yml`:

```
ansible-playbook -i hosts-vagrant.yml -e vars_file=vars-vagrant.yml middleware.yml
ansible-playbook -i hosts-vagrant.yml -e vars_file=vars-vagrant.yml --vault-password-file ~/vault-pass.txt application.yml
```

Hint: If you just want to generate the inventory file, run any vagrant command except `vagrant up`, e.g. `vagrant status`.

All playbooks are idempotent, meaning a second run of the `ansible-playbook` command should result in no changes made to the targets.

### Verification

Point a browser to `http://demo-web.local`, you should see a plain text page with data formatted as `<band> - <record>, <year>`.
The same data should be visible from `http://demo-app.local:5000`, formatted as an array of three arrays with three elements.
The same data should be visible on `demo-db.local` when issuing: `sudo -i -u postgres psql postgresql://demo:hunter2@127.0.0.1:5432/demo -c "SELECT * FROM records;"`

### Tests

Inspec tests are provided in [ansible/test](./test), see the [readme](./test/README.md) for details.

### What is being done

Ansible is run under a non-root user that has passwordless sudo (`vagrant`, or `ubuntu` in AWS). The main playbook, `playbook.yml`, simply includes the other two such as infra operations are kept separate from application deployment. The two playbooks can be run independently, but the application deployment will fail if the middleware is absent.

- Middleware (`middleware.yml`):

  - Frontend: the apache http server is installed, there is minimal configuration available - `ports.conf` is created from template, allowing for http/s ports to be set. The service is managed, also a handler is present to allow service restart when configuration changes (via notification).
  - Backend: the python ppa is setup as apt source and a custom version of python (`demo_python_version` -> 3.12) is installed.
  - Database: a postgresql server and client (`demo_postgresql_version` -> v17) are installed from the apt repo set up for this, some configuration is performed (via `lineinfile`), database service is managed (started). A handler is provided for service restart, when notified.

- Application (`application.yml`):

  - Frontend: The frontend code itself is a static html file, also created from template, to allow the backend URL to be set from parameters (in a real life situation the backend URL would be known beforehand, and this wouldn't be needed).
  - Backend: A virtual env is created, where the app's requirements.txt is processed. The backend app is a single file containing a Flask application that reads entries from a database and presents results via REST API. A service file is created from template as well, allowing for service management. The backend app is run in the virtual environment previously created, via `gunicorn` on port 5000. Handlers are present for restarting the web service when notified by resource changes, also for daemon reload after creating (or changing) the service file.
  - Database: Database, user, table, and data necessary for the application are added via a `shell` module, made idempotent with the help of a db query also in a shell block. This query will fail before the db is created, which is dealt with thru `ignore_errors: true`. (This could be solved with a custom fact, but that would require saving a plain text password in the fact script, while making a module for this operation seems overkill.) A handler is provided for service restart, when notified.

Resources that might expose secrets are protected by `no_log: true` statements.
