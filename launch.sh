#!/bin/bash

salt-cloud -m mongo-cluster.map -y -P &&
salt -t 30 -v \* saltutil.sync_all &&
salt -t 30 -v \* cmd.run "restart salt-minion" &&
sleep 60 &&
salt -t 300 -v -G replset_role:secondary state.highstate &&
salt -t 300 -v -G replset_role:primary state.highstate &&
salt -t 300 -v -G \* state.highstate &&
exit 0

exit 1

