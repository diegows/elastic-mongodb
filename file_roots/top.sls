
base:
  '*':
    - ssh-root
    - salt-minion
    - swap
    - hostsfile
    - nagios-nrpe

  'P@replset_name:.* and P@replset_role:.*':
    - match: compound
    - mongodb-base
    - mongodb-repl

  'P@shard_clustername:.*':
    - match: compound
    - mongodb-base
    - mongodb-sharding

