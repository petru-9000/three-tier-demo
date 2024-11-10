# Tests for the application server

# expected python version is installed
[
  'python3.12',
  'python3.12-venv',
  'python3.12-dev'
].each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

# validate venv demo-venv
describe file('/home/vagrant/demo-venv/bin/python') do
  it { should exist }
  it { should be_symlink }
  its('link_path') { should eq '/usr/bin/python3.12' }
end

# all requirements are installed
{
  gunicorn: '23.0.0',
  psycopg2: '2.9.10',
  Flask: '3.0.3',
  'Flask-Cors': '5.0.0'
}.each_pair do |p, v|
  describe pip(p, '/home/vagrant/demo-venv/bin/pip') do
    it { should be_installed }
    its('version') { should eq v }
  end
end

# verify we are running the our app in ~/demo-app and from the correct venv
describe file('/usr/lib/systemd/system/demo-app.service') do
  it { should exist }
  its('content') { should include 'Environment="PATH=/home/vagrant/demo-venv/bin"' }
  its('content') { should include 'Environment="DB_FQDN=demo-db.local"' }
  its('content') { should include 'WorkingDirectory=/home/vagrant/demo-app' }
  its('content') { should include 'ExecStart=/home/vagrant/demo-venv/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 app:app' }
end

# service enabled and up
describe service('demo-app') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# expected application is listening on the selected port
describe port(5000) do
  it { should be_listening }
  its('processes') { should include 'gunicorn' } # requires sudo
end

# backend endpoint returns expected content from the db
describe http('http://demo-app.local:5000/api/records') do
  its('status') { should cmp 200 }
  its('body') { should include 'Relayer' }
  its('headers.Content-Type') { should include 'application/json' }
end
