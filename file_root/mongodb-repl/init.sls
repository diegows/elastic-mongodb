
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
    - replset_name: {{ grains["replset_name"] }}
    - replset_role: {{ grains["replset_role"] }}
{% if  grains["replset_role"] == "primary"%}
    - replset_slaves: 
{% for slave in grains["replset_slaves"] %}
      - {{ slave }}
{% endfor %}
{% endif %}

{% endif %}

