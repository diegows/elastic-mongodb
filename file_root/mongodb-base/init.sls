
mongodb:
  pkgrepo:
    - managed
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - file: /etc/apt/sources.list.d/mongodb.list
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com
  pkg:
    - installed
    - name: mongodb-10gen
    - require:
      - pkgrepo: mongodb
  service:
    - name: mongodb
    - running
    - watch:
      - file: /etc/mongodb.conf
      - file: /etc/init/mongodb.conf

mongodb-upstart:
  file:
    - managed
    - name: /etc/init/mongodb.conf
    - source: salt://mongodb-base/mongodb-upstart.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: mongodb

/etc/mongodb.conf:
  file:
    - exists
    - require:
      - pkg: mongodb-10gen

salt-mine:
  file:
    - managed
    - name: /etc/salt/minion.d/mine.conf
    - source: salt://mongodb-base/salt-mine.conf
    - user: root
    - group: root
    - mode: 644

salt-mine-timeout-patch:
  file:
    - managed
    - name: /usr/lib/pymodules/python2.7/salt/modules/mine.py
    - source: salt://mongodb-base/mine.py
    - user: root
    - group: root
    - mode: 644

salt-minion:
  service:
    - running
    - watch:
      - pip: pymongo
      - file: salt-mine
      - file: salt-mine-timeout-patch

python-pip:
  pkg.installed

pymongo:
  pip:
    - installed
    - require:
      - pkg: python-pip

