
/root/.ssh/authorized_keys:
  file.managed:
    - source: salt://ssh-root/files/authorized_keys
    - mode: 600
