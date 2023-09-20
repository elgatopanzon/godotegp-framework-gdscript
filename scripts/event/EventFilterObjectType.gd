######################################################################
# @author      : ElGatoPanzon
# @class       : EventFilterObjectType
# @created     : Wednesday Sep 20, 2023 14:22:37 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Filter events by owner object type instance
######################################################################

class_name EventFilterObjectType
extends EventFilter

var _object_type

# object constructor
func _init(object_type):
	_object_type = object_type

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventFilterObjectType"

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

# check if event owner matches desired object type
func match(event: Event):
	return is_instance_of(event._owner, _object_type)

func get_broadcast_method_string():
	return "type_%s" % _object_type.get_path().get_file().replace(".gd", "")
