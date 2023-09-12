######################################################################
# @author      : ElGatoPanzon
# @class       : EventFilterCustom
# @created     : Monday Sep 11, 2023 14:42:57 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Implement a custom EventFilter using Callable in match()
######################################################################

class_name EventFilterCustom
extends EventFilter

var _callable: Callable

# object constructor
func _init(callable: Callable):
	_callable = callable

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventFilterCustom"

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
	var match_result = _callable.call(event)

	logger().debug("match result: match_result=%s" % [match_result], "event", event)

	return match_result
