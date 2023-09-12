######################################################################
# @author      : ElGatoPanzon
# @class       : EventFilterObject
# @created     : Monday Sep 11, 2023 17:17:48 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : EventFilter to filter by Event's object instance
######################################################################

class_name EventFilterObject
extends EventFilter

var _object: Object

# object constructor
func _init(object):
	_object = object

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventFilterObject"

func get_broadcast_method_string():
	return null

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

func match(event: Event):
	return event._owner == _object
