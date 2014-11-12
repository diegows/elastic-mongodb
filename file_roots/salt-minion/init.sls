
salt-minion:
  service.running:
    - enable: true

salt-mine:
  file.managed:
    - name: /etc/salt/minion.d/mine.conf
    - source: salt://salt-minion/files/salt-mine.conf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: salt-minion

