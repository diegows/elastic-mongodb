
{% if grains.get("shard_configsvr", False) %}

mongodb-cfglib:
  file:
    - directory
    - name: /var/lib/mongodb-configsvr/
    - user: mongodb
    - group: mongodb

mongodb-configsvr-upstart:
  file:
    - managed
    - name: /etc/init/mongodb-configsvr.conf
    - source: salt://mongodb-sharding/mongodb-configsvr-upstart.conf
    - user: root
    - group: root

mongodb-configsvr.conf:
  file:
    - managed
    - name: /etc/mongodb-configsvr.conf
    - source: salt://mongodb-sharding/mongodb-configsvr.conf
    - user: root
    - group: root

mongodb-configsvr:
  service:
    - running
    - require:
      - file: /etc/init/mongodb-configsvr.conf
      - file: mongodb-configsvr.conf
      - file: mongodb-configsvr-upstart
      - file: mongodb-cfglib
      - pkg: mongodb
    - watch:
      - file: /etc/init/mongodb-configsvr.conf
      - file: mongodb.conf

{% endif %}

{% if grains.get("shard_mongos", False) %}

mongos.conf:
  file:
    - managed
    - name: /etc/mongos.conf
    - source: salt://mongodb-sharding/mongos.conf
    - user: root
    - group: root
    - template: jinja

mongos-upstart:
  file:
    - managed
    - name: /etc/init/mongos.conf
    - source: salt://mongodb-sharding/mongos-upstart.conf
    - user: root
    - group: root
    - template: jinja

{% endif %}

