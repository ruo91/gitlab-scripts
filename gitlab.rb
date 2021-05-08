## GitLab URL
##! URL on which GitLab will be reachable.
##! For more details on configuring external_url see:
##! https://docs.gitlab.com/omnibus/settings/configuration.html#configuring-the-external-url-for-gitlab
##!
##! Note: During installation/upgrades, the value of the environment variable
##! EXTERNAL_URL will be used to populate/replace this value.
##! On AWS EC2 instances, we also attempt to fetch the public hostname/IP
##! address from AWS. For more details, see:
##! https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html
external_url 'http://gitlab.ocp4.ybkim.local'

# Time Zone
gitlab_rails['time_zone'] = 'Asia/Seoul'

### GitLab Redis settings
###! Connect to your own Redis instance
###! Docs: https://docs.gitlab.com/omnibus/settings/redis.html

#### Redis TCP connection
# gitlab_rails['redis_host'] = "redis-server"
# gitlab_rails['redis_port'] = 6379
# gitlab_rails['redis_ssl'] = false
# gitlab_rails['redis_password'] = nil
# gitlab_rails['redis_database'] = 0
# gitlab_rails['redis_enable_client'] = true

#### Redis local UNIX socket (will be disabled if TCP method is used)
#gitlab_rails['redis_socket'] = "/var/run/redis/redis-server.sock"


## Enable Redis
redis['enable'] = false

## Disable all other services
sidekiq['enable'] = true
gitlab_workhorse['enable'] = true
unicorn['enable'] = true
postgresql['enable'] = true
nginx['enable'] = true
prometheus['enable'] = true
alertmanager['enable'] = false
pgbouncer_exporter['enable'] = true
gitlab_exporter['enable'] = true
gitaly['enable'] = true

#redis['bind'] = '0.0.0.0'
#redis['port'] = 6379
#redis['password'] = 'SECRET_PASSWORD_HERE'

gitlab_rails['enable'] = true

## MS Active Directory ##
#gitlab_rails['ldap_enabled'] = true
#gitlab_rails['prevent_ldap_sign_in'] = false
#gitlab_rails['ldap_servers'] = YAML.load <<-EOS # remember to close this block with 'EOS' below
#  main:
#    label: 'MS Active Directory'
#    host: 'ip or fqdn'
#    port: 389
#    method: 'plain'
#    uid: 'sAMAccountName'
#    bind_dn: 'CN=Administrator,CN=Users,DC=example,DC=com'
#    password: 'Admin Pass'
#    timeout: 10
#    active_directory: true
#    allow_username_or_email_login: true
#    block_auto_created_users: false
#    base: 'DC=example,DC=com'
#EOS
