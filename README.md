elastic-mongodb
===============

MongoDB oschestration based on SaltStack.

HOWTO
-----

Set replset_name and replset_role grains to every minion.

Roles must be primary or secondary. Only one minion can be primary.

ROADMAP
-------

- Basic replica set configuration.
- Support for delayed replica set members.
- Basic sharding support.
- Sharding + Repl sets.
- Salt cloud integration.

TODO
----

- Create dependencias between minions. For example, primary configuration fails
  if secondaries doesn't have the grains replset_name and replset_role.
- tests!!!
