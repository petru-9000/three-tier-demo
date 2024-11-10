demo_pub_key            = 
demo_private_key_file   = "ansible/id_rsa"
aws_region              = "us-east-1"
subnet_az               = "us-east-2a"
web_flavor              = "t3.micro"
app_flavor              = "t3.micro"
db_flavor               = "t3.micro"
demo_cidr_block         = "10.0.10.0/24"
ami_default_user        = "ubuntu"

# ansible vars
ansible_vault_pass_file = "~/vault-pass.txt"
# Frontend
ansible_apache_http_port = "80"
ansible_apache_https_port = "443"
# Backend
ansible_python_version = "3.12"
# Database
ansible_postgresql_version = "17"
# Application
# Frontend
ansible_backend_endpoint = "/api/records"
# Backend & Database
ansible_db_fqdn = "demo-db.local"
ansible_db_name = "demo"
ansible_db_user = "demo"
ansible_db_password = "!vault |
  $ANSIBLE_VAULT;1.1;AES256
  38396162653831303732303464383065396233643834633834643530363631626361633361643363
  3433333334303863326262313839363464666137323462630a346432343665633165373565373739
  65376432336563616531316665393336353239373738383936346461623333333532653434613235
  3661353937353433610a303466656164326465393534316164393733373563396433306466306466
  3362"
