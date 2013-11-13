elastic-mongodb
===============

MongoDB oschestration based on SaltStack.

Tested with
-----------

- Ubuntu 12.04
- Salt 0.17.1
- Salt Cloud 0.8.9-stable from https://github.com/vhgroup/salt-cloud.git.

HOWTO
-----

- Set replset_name and replset_role grains to every minion.
- Roles must be primary or secondary. Only one minion can be primary per set.


```
apt-get install python-pip git
pip install apache-libcloud==0.13.2
wget -O - http://bootstrap.saltstack.org | sh -s -- -M
USE_SETUPTOOLS=1 pip install -e git+https://github.com/vhgroup/salt-cloud.git@v0.8.9-stable#egg=salt-cloud
```

Setup provider, profile and map. See examples below.

ssh to master

```
salt \* test.ping
salt \* grains.item replset_role replset_name
apt-get install git
git clone https://github.com/vhgroup/elastic-mongodb.git
cd elastic-mongodb
cp -a file_root/ /srv/salt
```

ROADMAP
-------

- Basic replica set configuration. DONE
- Basic sharding support. DONE
- Sharding + Repl sets. DONE
- Salt cloud integration.
- Support for delayed replica set members.

TODO
----

- Create dependencies between minions. For example, primary configuration fails
  if secondaries doesn't have the grains replset_name and replset_role.
- tests!!!
- Check with mine_functions doesn't work in the pillars.
- mine_functions should accept a function name argument to avoid confusion with
  you use something like grains.get as function.
- Move mongodb.conf state to mongodb-base.

