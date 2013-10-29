
mongodb-install:
  file: 
    - managed
    - source: salt://mongodb-base/source.list.ubuntu
    - name: /etc/apt/sources.list.d/mongodb.list
  pkg:
    - installed
    - name: mongodb-10gen
  service:
    - name: mongodb
    - running
