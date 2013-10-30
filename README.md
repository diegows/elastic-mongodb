elastic-mongodb
===============

MongoDB oschestration based on SaltStack.

ROADMAP
-------

- Basic replica set configuration.
- Support for delayed replica set members.
- Basic sharing support.
- Sharing + Repl sets.
- Salt cloud integration.

TODO
----

- Create dependencias between minions. For example, primary configuration fails
  if secondaries doesn't have the grains replset_name and replset_role.
- tests!!!
