
def _build_member_list(members):
    ret = []
    members = list(enumerate(members))
    for member in members:
        ret.append(dict(_id=member[0], host=member[1]))

    return ret

def repl_managed(name):
    ret = {
            'name' : name,
            'changes' : {},
            'result' : True,
            'comment' : '' }

    replset_name = __grains__.get("replset_name")
    replset_role = __grains__.get("replset_role")
    replset_slaves = __grains__.get("replset_slaves", [])
    if type(replset_slaves) != list:
        ret["result"] = False
        ret["comment"] = "replset_slaves MUST be a list"

    if replset_name and replset_role == "primary":
        repl_config =  __salt__['mongodbext.repl_show_config']()
        if repl_config is None:
            repl_config = { '_id' : replset_name, 'version' : 1 }
            repl_config['members'] = _build_member_list(replset_slaves)
            __salt__['mongodbext.repl_init'](repl_config)

            ret["comment"] = "Repl wasn't initiated, initiating..."
            ret["changes"][name] = 'initiatied'

        else:
            ret["comment"] = "Repl already initiated."

        new_members = []
        for slave in replset_slaves:
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

