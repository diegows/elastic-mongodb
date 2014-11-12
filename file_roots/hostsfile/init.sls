
/etc/hosts:
  file.managed:
    - source: salt://hostsfile/files/hosts.jinja
    - template: jinja
    - mode: 644

