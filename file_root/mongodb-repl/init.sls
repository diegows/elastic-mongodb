
{% if grains.has_key("replset_name") and grains.has_key("replset_role") %}

{% set replset_secondaries = [] %}
{% if  grains["replset_role"] == "primary"%}
  {% for minion, role in salt['mine.get']('*', 'replset_role').items() %}
    {% if role == "secondary"%}
      {% do replset_secondaries.append(minion) %}
    {% endif %}
  {% endfor %}
{% endif %}

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
    - replset_secondaries: 
{% for secondary in replset_secondaries %}
      - {{ secondary }}
{% endfor %}
{% endif %}

{% endif %}

