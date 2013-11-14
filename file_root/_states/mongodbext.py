
import socket

from pymongo.errors import OperationFailure

def _build_member_list(members):
    ret = []
    members.append(socket.getfqdn())
    members = list(enumerate(members))
    for member in members:
        ret.append(dict(_id=member[0], host=member[1]))

    return ret

def repl_managed(name, 
        replset_name,
        replset_role,
        replset_secondaries = []):

    ret = {
            'name' : name,
            'changes' : {},
            'result' : True,
            'comment' : '' }

    if type(replset_secondaries) != list:
        ret["result"] = False
        ret["comment"] = "replset_secondaries MUST be a list"

    if replset_name and replset_role == "primary":
        repl_config =  __salt__['mongodbext.repl_show_config']()
        if repl_config is None:
            repl_config = { '_id' : replset_name, 'version' : 1 }
            repl_config['members'] = _build_member_list(replset_secondaries)
            __salt__['mongodbext.repl_init'](repl_config)

            ret["comment"] = "Repl wasn't initiated, initiating..."
            ret["changes"][name] = 'initiatied'

        else:
            ret["comment"] = "Repl already initiated."

        new_members = []
        for slave in replset_secondaries:
            if not ":" in slave:
                slave = slave + ":27017"
            if not any(slave == i['host'] for i in repl_config['members']):
                new_members.append(slave)

        if len(new_members) > 0:
            new_members = (map(lambda x: x['host'], repl_config['members']) +
                            new_members)
            new_members = _build_member_list(new_members)
            repl_config['members'] = new_members
            repl_config['version'] += 1
            __salt__['mongodbext.repl_reconfig'](repl_config)

    return ret


def set_shards(name, shards=[], port=27017, collection=None, database=None):
    ret = {
            'name' : name,
            'changes' : {},
            'result' : True,
            'comment' : '' }

    current_shards = __salt__['mongodbext.list_shards'](port=port)["shards"]
    current_shards = map(lambda x: x["host"], current_shards)
    # TODO: do this better please! :)
    current_shards = ",".join(current_shards)
    for shard in shards:
        if shard not in current_shards:
            try:
                __salt__['mongodbext.add_shard'](shard, port=port)
                ret["changes"][shard] = "shard added"
            except Exception:
                continue

    #TODO: Check if the database and the collections is sharded in the config
    #DB.
    try:
        __salt__['mongodbext.db_enable_sharding'](database, port=port)
        __salt__['mongodbext.shard_collection'](collection, port=port)
    except OperationFailure:
        pass

    return ret

