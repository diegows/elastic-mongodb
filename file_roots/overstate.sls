
mongodb-primaries:
  match: 'G@replset_role:primary'
  require:
    - mongodb-slaves

mongodb-slaves:
  match: 'G@replset_role:secondary'

all:
  match: '*'
  require:
    - mongodb-primaries

