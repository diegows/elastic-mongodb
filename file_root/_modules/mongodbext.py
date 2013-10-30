'''
Module to provide extended functionality to MongoDB Salt module.

TODO:
    - Try to merge this in the oficial SaltStack.

Diego Woitasen - <diego.woitasen@vhgroup.net>
VHGroup
'''

from pymongo import *

def connect():
    c = MongoClient()
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
    c.admin.command("replSetReconfig", config)
    return True

