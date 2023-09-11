######################################################################
# @author      : ElGatoPanzon
# @class       : EventTest
# @created     : Sunday Sep 10, 2023 22:19:11 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Test event which isn't type EventBasic
######################################################################

class_name EventTest
extends Event

var _owner

# object constructor
func _init(owner):
	_owner = owner

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventTest"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

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

