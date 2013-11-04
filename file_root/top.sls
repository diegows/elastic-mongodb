
base:
  '*':
    - mongodb-base

  'P@replset_name:.* and P@replset_role:.*':
    - match: compound
    - mongodb-repl

