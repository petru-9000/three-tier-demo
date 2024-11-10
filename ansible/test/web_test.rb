# Tests for the web server

# software is installed
describe package('apache2') do
  it { should be_installed }
end

# service enabled and up
describe service('apache2') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# expected application is listening on the selected port
describe port(80) do
  it { should be_listening }
  its('processes') { should include 'apache2' } # requires sudo
end

# expected content, including backend URL
describe file('/var/www/html/index.html') do
  its('content') { should include 'http://demo-app.local:5000/api/records' }
end

# expected content is served
describe http('http://demo-web.local:80') do
  its('status') { should cmp 200 }
  its('body') { should include 'http://demo-app.local:5000/api/records' }
  its('headers.Content-Type') { should include 'text/html' }
end
