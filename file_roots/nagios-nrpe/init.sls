
{%- if grains.get("environment") != "vagrant" %}

{% if grains.get("os") in  [ "CentOS", "Redhat"] %}

nagios-plugins:
  pkg.installed:
    - pkgs:
      - nagios-plugins-procs
      - nagios-plugins-users
      - nagios-plugins-load
      - nagios-plugins-disk
      - nagios-plugins-tcp
      - nagios-plugins-mysql

nrpe:
  pkg.installed: []
  service.running:
    - enable: true
    - watch:
      - file: {{ pillar["nrpe_conf_dir"] }}
    - require:
      - pkg: nagios-plugins

{% else %}

nrpe:
  pkg.installed:
    - name: nagios-nrpe-server
  service.running:
    - name: nagios-nrpe-server
    - enable: true
    - watch:
      - file: {{ pillar["nrpe_conf_dir"] }}

{% endif %}

{{ pillar["nrpe_conf_dir"] }}:
  file.directory:
    - mode: 755
    - user: root
    - group: root

{{ pillar["nrpe_conf_path"] }}:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - source: salt://nagios-nrpe/files/nrpe.cfg
    - template: jinja
    - require:
      - pkg: nrpe
    - watch_in:
      - service: nrpe

{{ pillar["nagios_plugins_dir"] }}/check_cpu:
  file.managed:
    - source: salt://nagios-nrpe/files/check_cpu_perf.sh
    - user: root
    - group: root
    - mode: 755

{{ pillar["nagios_plugins_dir"] }}/check_file_exists:
  file.managed:
    - source: salt://nagios-nrpe/files/check_file_exists.sh
    - user: root
    - group: root
    - mode: 755

{{ pillar["nagios_plugins_dir"] }}/check_ps:
  file.managed:
    - source: salt://nagios-nrpe/files/check_ps.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja

{% endif %}

