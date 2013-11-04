
base:
  '*':
    - mongodb-base

  'P@replset_name:.* and P@replset_role:.*':
    - match: compound
    - mongodb-repl

  'P@shard_clustername:.*':
    - match: compound
    - mongodb-sharding

