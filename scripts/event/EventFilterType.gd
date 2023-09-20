######################################################################
# @author      : ElGatoPanzon
# @class       : EventFilterType
# @created     : Sunday Sep 10, 2023 21:59:12 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Filter events by Event name
######################################################################

class_name EventFilterType
extends EventFilter

var _event_type

# object constructor
func _init(event_type):
	_event_type = event_type

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventFilterType"

func get_broadcast_method_string():
	return null

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
	var match_result = is_instance_of(event, _event_type)

	logger().debug("match result: type=%s, match_result=%s" % [_event_type.get_path().get_file().replace(".gd", ""), match_result], "event", event)

	return match_result
