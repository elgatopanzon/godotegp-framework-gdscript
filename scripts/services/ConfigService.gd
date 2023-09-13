######################################################################
# @author      : ElGatoPanzon
# @class       : ConfigService
# @created     : Wednesday Sep 13, 2023 17:29:10 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service handling reading and writing config files
######################################################################

class_name ConfigService
extends Service

# object constructor
func _init():
	pass

func init():
	return self

# friendly name when printing object
func _to_string():
	return "ConfigService"

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

