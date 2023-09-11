######################################################################
# @author      : ElGatoPanzon
# @class       : EventSubscription
# @created     : Sunday Sep 10, 2023 23:03:31 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Holds information about a subscription to an Event
######################################################################

class_name EventSubscription
extends Resource

var _subscriber: Object
var _event_type
var _event_filters: Array

# object constructor
func _init(subscriber: Object, event_type, event_filters: Array = []):
	_subscriber = subscriber
	_event_type = event_type
	_event_filters = event_filters

# friendly name when printing object
func _to_string():
	return "EventSubscription"

func as_dict():
	return {
		"subscriber": _subscriber.to_string(),
		"event_type": _event_type.get_path().get_file().replace(".gd", ""),
		"event_filters": _event_filters
	}

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

