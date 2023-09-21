######################################################################
# @author      : ElGatoPanzon
# @class       : EventServicesReady
# @created     : Thursday Sep 21, 2023 13:39:46 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Event emitted when all ServiceManager events reached ready state
######################################################################

class_name EventServicesReady
extends Event

# object constructor
func _init():
	pass

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventServicesReady"

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

