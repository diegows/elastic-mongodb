'''
Module to provide extended functionality to MongoDB Salt module.

TODO:
    - Try to merge this in the oficial SaltStack.

Diego Woitasen - <diego.woitasen@vhgroup.net>
VHGroup
'''

from pymongo import *
from pymongo.errors import OperationFailure

def connect(port=27017):
    c = MongoClient(port=port)
    return c

def db_connect(name):
    c = connect()
    return c[name]

def repl_show_config():
    '''Display replication configuration.'''
    db = db_connect("local")

    repl_info = db.system.replset.find()
    if repl_info.count() == 0:
        return None
    
    return repl_info[0]

def repl_init(config=None):
    ''' Initialize replication only on the master.'''
    c = connect()
    if repl_show_config() is None:
        c.admin.command("replSetInitiate", config)
        return False

    return True

def repl_reconfig(config):
    c = connect()
    try:
        c.admin.command("replSetReconfig", config)
    except OperationFailure:
        pass
    return True

def add_shard(host, port=27017):
    c = connect(port)
    c.admin.command(dict(addShard=host))
    return True

def list_shards(port=27017):
    c = connect(port)
    return c.admin.command(dict(listShards=1))

def db_enable_sharding(db, port=27017):
    c = connect(port)
    return c.admin.command(dict(enableSharding=db))

def shard_collection(collection, key, port=27017):
    c = connect(port)
    return c.admin.command(dict(shardCollection=collection, key=dict(key=key)))

