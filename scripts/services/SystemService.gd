######################################################################
# @author      : ElGatoPanzon
# @class       : SystemService
# @created     : Tuesday Sep 12, 2023 12:10:20 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service offering access to system-related functionality
######################################################################

class_name SystemService
extends Service

var _system_objects: Dictionary

# object constructor
func _init():
	_system_objects["OS"] = OS
	_system_objects["Time"] = Time
	_system_objects["Engine"] = Engine
	_system_objects["Performance"] = Performance

func init():
	return self

# friendly name when printing object
func _to_string():
	return "SystemService"

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

func _get(system_object):
	return _system_objects.get(system_object, null)
