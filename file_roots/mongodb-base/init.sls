
mongodb:
  pkgrepo:
    - managed
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - file: /etc/apt/sources.list.d/mongodb.list
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com
  pkg:
    - installed
    - name: mongodb-org
    - require:
      - pkgrepo: mongodb
  service:
    - running
    - name: mongod
    - watch:
      - file: /etc/mongod.conf

/etc/mongod.conf:
  file.replace:
    - pattern: ^bind_ip.*
    - repl: bind_ip = 127.0.0.1,{{ grains.get("ip_interfaces", {}).get("eth1", "127.0.0.1")|first }},{{ grains.get("ip_interfaces", {}).get("eth0", "127.0.0.1")|first }}
    - require:
      - pkg: mongodb-org

python-pip:
  pkg.installed

pymongo:
  pip.installed:
    - require:
      - pkg: python-pip

