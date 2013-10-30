
{% if grains.has_key("replset_name") and grains.has_key("replset_role") %}

mongodb.conf:
  file:
    - append
    - name: /etc/mongodb.conf
    - text: replSet = {{ grains["replset_name"] }}


mongoset:
  mongodbext:
    - repl_managed
    - require:
      - service.running: mongodb

{% endif %}

