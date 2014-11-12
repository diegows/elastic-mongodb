PWD=$(shell pwd)

all: salt-master 

/usr/bin/salt-master:
	test -d /etc/salt || mkdir /etc/salt
	curl -L https://bootstrap.saltstack.com -o /tmp/install_salt.sh
	sh /tmp/install_salt.sh -L -M -P git v2014.7.0rc7
	pip install apache-libcloud
	pip install pymongo

salt-master: /usr/bin/salt-master
	ln -sf $(PWD)/cloud.providers /etc/salt/cloud.providers
	ln -sf $(PWD)/cloud.profiles /etc/salt/cloud.profiles
	ln -sf $(PWD)/install_salt.sh /etc/salt/install_salt.sh
	chmod 400 *.pub *.pem
	test -d /etc/salt/master.d || mkdir /etc/salt/master.d
	sed s%PILLAR_ROOTS%$(PWD)/pillar_roots% \
		master.d/pillar_roots.conf > /etc/salt/master.d/pillar.conf
	sed s%FILE_ROOTS%$(PWD)/file_roots% \
		master.d/file_roots.conf > /etc/salt/master.d/file.conf
	echo master: localhost > /etc/salt/minion.d/master.conf
	-stop salt-master
	-stop salt-minion
	start salt-master
	start salt-minion

