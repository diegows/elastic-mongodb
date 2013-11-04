
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

salt-mine:
  file:
    - managed
    - name: /etc/salt/minion.d/mine.conf
    - source: salt://mongodb-base/salt-mine.conf
    - user: root
    - group: root
    - mode: 644

salt-minion:
  service:
    - running
    - watch:
      - pip: pymongo
      - file: salt-mine

python-pip:
  pkg.installed

pymongo:
  pip:
    - installed
    - require:
      - pkg: python-pip

/etc/mongodb.conf:
  file:
    - exists
    - require:
      - pkg: mongodb-10gen

