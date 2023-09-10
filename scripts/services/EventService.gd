######################################################################
# @author      : ElGatoPanzon
# @class       : EventService
# @created     : Sunday Sep 10, 2023 16:19:27 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Manage EventQueue instances and provide easy interfaces
######################################################################

class_name EventService
extends ServiceManagerService

# object constructor
func _init():
	pass

func init():
	return self

# used by LoggerService
func get_logger_name():
	return "EventService"

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

