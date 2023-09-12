######################################################################
# @author      : ElGatoPanzon
# @class       : EventFilterGroup
# @created     : Monday Sep 11, 2023 17:26:00 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : EventFilter checking if the object node is in a group
######################################################################

class_name EventFilterGroup
extends EventFilter

var _node_group: String

# object constructor
func _init(node_group: String):
	_node_group = node_group

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventFilterGroup"

func get_broadcast_method_string():
	return "group_"+_node_group

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
	return event._owner.is_in_group(_node_group)
