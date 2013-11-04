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
- Basic sharding support.
- Sharding + Repl sets.
- Salt cloud integration.
- Support for delayed replica set members.

TODO
----

- Create dependencias between minions. For example, primary configuration fails
  if secondaries doesn't have the grains replset_name and replset_role.
- tests!!!
- Check with mine_functions doesn't work in the pillars.
- mine_functions should accept a function name argument to avoid confusion with
  you use something like grains.get as function.
