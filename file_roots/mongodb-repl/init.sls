
{% set replset_secondaries = [] %}
{% if grains.get("replset_role") == "primary" %}
  {% for minion, peer_grains in salt['mine.get']('*', 'grains.item').items() %}
    {% if peer_grains.get("replset_role") == "secondary" and grains.get("replset_name") == peer_grains.get("replset_name") %}
      {% do replset_secondaries.append(peer_grains["fqdn"]) %}
    {% endif %}
  {% endfor %}
{% endif %}

mongod.conf:
  file:
    - append
    - name: /etc/mongod.conf
    - text: replSet = {{ grains["replset_name"] }}

mongoset:
  mongodbext:
    - repl_managed
    - require:
      - service: mongod
    - replset_name: {{ grains["replset_name"] }}
    - replset_role: {{ grains["replset_role"] }}
{% if  grains.get("replset_role") == "primary"%}
    - replset_secondaries: 
{% for secondary in replset_secondaries %}
      - {{ secondary }}
{% endfor %}
{% endif %}

