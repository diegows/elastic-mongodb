chef:
  ntp_sync: False
  lookup:
    client: chef-client
    confdir: /etc/chef
  client_rb:
    chef_server_url: https://192.237.173.216
    log_level: :info
    log_location: "'/var/log/chef-client.log'"
    validation_client_name: chef-validator
    validation_key: /etc/chef/validation.pem

