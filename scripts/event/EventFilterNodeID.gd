######################################################################
# @author      : ElGatoPanzon
# @class       : EventFilterNodeID
# @created     : Monday Sep 11, 2023 17:30:47 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : EventFilter to filter by node name or node metadata ID
######################################################################

class_name EventFilterNodeID
extends EventFilter

var _id: String

# object constructor
func _init(id: String):
	_id = id

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventFilterNodeID"

func get_broadcast_method_string():
	return _id

# integration with Services.Log
func logger():
	Services.Log.get(self.to_string()).set_level("warning")
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
	var matched = _id == event._owner.get_name()

	# if it didn't match by name, try by ID
	if not matched:
		if event._owner.has_meta("id"):
			if event._owner.get_meta("id") == _id:
				matched = true

	return matched
