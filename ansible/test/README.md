# Tests for the Ansible deployment of the three-tier app demo

The tests are run with Chef's `inspec` (paid) otr its open source (free) version, [cinc auditor](https://cinc.sh/start/auditor/).

From this directory, after deploying the app locally (in Vagrant):

```
cinc-auditor exec --sudo -t ssh://vagrant:vagrant@demo-web.local web_test.rb
cinc-auditor exec --sudo -t ssh://vagrant:vagrant@demo-app.local app_test.rb
cinc-auditor exec --sudo -t ssh://vagrant:vagrant@demo-db.local db_test.rb
```

Or to run all:

```
for component in web app db; do
  cinc-auditor exec --sudo -t ssh://vagrant:vagrant@demo-${component}.local ${component}_test.rb
done
```

A succsessful run will display this:

```
Profile:   tests from web_test.rb (tests from web_test.rb)
Version:   (not specified)
Target:    ssh://vagrant@demo-web.local:22
Target ID: d322de65-caec-56a7-b1a6-59ad9b997341

  System Package apache2
     ✔  is expected to be installed
  Service apache2
     ✔  is expected to be installed
     ✔  is expected to be enabled
     ✔  is expected to be running
  Port 80
     ✔  is expected to be listening
     ✔  processes is expected to include "apache2"
  File /var/www/html/index.html
     ✔  content is expected to include "http://demo-app.local:5000/api/records"
  HTTP GET on http://demo-web.local:80
     ✔  status is expected to cmp == 200
     ✔  body is expected to include "http://demo-app.local:5000/api/records"
     ✔  headers.Content-Type is expected to include "text/html"

Test Summary: 10 successful, 0 failures, 0 skipped

Profile:   tests from app_test.rb (tests from app_test.rb)
Version:   (not specified)
Target:    ssh://vagrant@demo-app.local:22
Target ID: 1eec03c6-2e3d-53c0-881a-7804e0bdd265

  System Package python3.12
     ✔  is expected to be installed
  System Package python3.12-venv
     ✔  is expected to be installed
  System Package python3.12-dev
     ✔  is expected to be installed
  File /home/vagrant/demo-venv/bin/python
     ✔  is expected to exist
     ✔  is expected to be symlink
     ✔  link_path is expected to eq "/usr/bin/python3.12"
  Pip Package gunicorn
     ✔  is expected to be installed
     ✔  version is expected to eq "23.0.0"
  Pip Package psycopg2
     ✔  is expected to be installed
     ✔  version is expected to eq "2.9.10"
  Pip Package Flask
     ✔  is expected to be installed
     ✔  version is expected to eq "3.0.3"
  Pip Package Flask-Cors
     ✔  is expected to be installed
     ✔  version is expected to eq "5.0.0"
  File /usr/lib/systemd/system/demo-app.service
     ✔  is expected to exist
     ✔  content is expected to include "Environment=\"PATH=/home/vagrant/demo-venv/bin\""
     ✔  content is expected to include "Environment=\"DB_HOST=demo-db.local\""
     ✔  content is expected to include "WorkingDirectory=/home/vagrant/demo-app"
     ✔  content is expected to include "ExecStart=/home/vagrant/demo-venv/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 app:app"
  Service demo-app
     ✔  is expected to be installed
     ✔  is expected to be enabled
     ✔  is expected to be running
  Port 5000
     ✔  is expected to be listening
     ✔  processes is expected to include "gunicorn"
  HTTP GET on http://demo-app.local:5000/api/records
     ✔  status is expected to cmp == 200
     ✔  body is expected to include "Relayer"
     ✔  headers.Content-Type is expected to include "application/json"

Test Summary: 27 successful, 0 failures, 0 skipped

Profile:   tests from db_test.rb (tests from db_test.rb)
Version:   (not specified)
Target:    ssh://vagrant@demo-db.local:22
Target ID: 7c507afb-82fa-5f42-8f7a-b398ec502e4b

  System Package python3-psycopg2
     ✔  is expected to be installed
  System Package libpq-dev
     ✔  is expected to be installed
  System Package postgresql-17
     ✔  is expected to be installed
  System Package postgresql-client-17
     ✔  is expected to be installed
  File /etc/postgresql/17/main/postgresql.conf
     ✔  is expected to exist
     ✔  content is expected to match /^listen_addresses = \'\*\'$/
     ✔  content is expected to match /^ssl = false$/
     ✔  content is expected to match /^max_connections = 1000$/
  File /etc/postgresql/17/main/pg_hba.conf
     ✔  is expected to exist
     ✔  content is expected to match /^host demo demo 0.0.0.0\/0 md5$/
  Service postgresql
     ✔  is expected to be installed
     ✔  is expected to be enabled
     ✔  is expected to be running
  Port 5432
     ✔  is expected to be listening
     ✔  processes is expected to include "postgres"
  Command: `sudo -i -u postgres psql postgres://demo:hunter2@127.0.0.1:5432/demo -c 'select * from records'`
     ✔  exit_status is expected to eq 0
     ✔  stderr is expected to eq ""
     ✔  stdout is expected to match /^\(3 rows\)$/
     ✔  stdout is expected to match /Revolver/
     ✔  stdout is expected to match /Relayer/
     ✔  stdout is expected to match /Discipline/

Test Summary: 21 successful, 0 failures, 0 skipped
```
