
salt-minion:
  match: '*'
  sls:
    - salt-minion
  function:
    saltutils.sync_all

mongodb-primaries:
  match: 'G@replset_role:primary'
  require:
    - mongodb-slaves

mongodb-slaves:
  match: 'G@replset_role:secondary'
  require:
    - salt-minion

mongodb-cfgservers:
  match: 'G@shard_configsvr:true'

mongodb-mongos:
  match: 'G@shard_mongos:true'
  require:
    - mongodb-primaries
    - mongodb-cfgservers

all:
  match: '*'
  require:
    - mongodb-mongos

