######################################################################
# @author      : ElGatoPanzon
# @class       : EventNodeRemoved
# @created     : Monday Sep 11, 2023 19:30:17 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Event emitted when node removed from the scene
######################################################################

class_name EventNodeRemoved
extends EventNodeAdded

# object constructor
func _init(owner: Object, node: Node):
	_owner = owner
	_node = node

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventNodeRemoved"

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

