######################################################################
# @author      : ElGatoPanzon
# @class       : EventBasic
# @created     : Sunday Sep 10, 2023 19:34:46 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Basic event accepting Owner and Data
######################################################################

class_name EventBasic
extends Event

# event data
var _owner
var _data

# object constructor
func _init(owner: Object, data):
	_owner = owner
	_data = data

func init():
	return self

func _to_string():
	return "EventBasic"

func to_dict():
	return {
		"single_consume": _single_consume,
		"owner": _owner,
		"data": _data,
	}

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

# object destructor
# func _notification(what):
#     if (what == NOTIFICATION_PREDELETE):
#         pass


# scene lifecycle methods
# called when node enters the tree
# func _enter_tree():
# 	pass

# called once when node is ready
# func _ready():
#	pass

# called when node exits the tree
# func _exit_tree():
#	pass


# process methods
# called during main loop processing
# func _process(delta: float):
#	pass

# called during physics processing
# func _physics_process(delta: float):
#	pass

