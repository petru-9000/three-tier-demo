# Tests for the database server

# software and its prereqs are installed
[
  'python3-psycopg2',
  'libpq-dev',
  'postgresql-17',
  'postgresql-client-17',
].each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

# listening on all IP's
describe file('/etc/postgresql/17/main/postgresql.conf') do
  it { should exist }
  its('content') { should match /^listen_addresses = \'\*\'$/ } # defaults to localhost
  its('content') { should match /^ssl = false$/ }
  its('content') { should match /^max_connections = 1000$/ }
end

# allowing client authentication with encrypted password, from all IP's
describe file('/etc/postgresql/17/main/pg_hba.conf') do
  it { should exist }
  its('content') { should match /^host demo demo 0.0.0.0\/0 md5$/ } # requires sudo
end

# service enabled and up
describe service('postgresql') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# expected application is listening on the selected port
describe port(5432) do
  it { should be_listening }
  its('processes') { should include 'postgres' } # requires sudo
end

# validate table data
describe command("sudo -i -u postgres psql postgres://demo:hunter2@127.0.0.1:5432/demo -c 'select * from records'") do
  its('exit_status') { should eq 0 }
  its('stderr') { should eq '' }
  its('stdout') { should match /^\(3 rows\)$/ }
  its('stdout') { should match /Revolver/ }
  its('stdout') { should match /Relayer/ }
  its('stdout') { should match /Discipline/ }
end
