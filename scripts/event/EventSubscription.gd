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
var _subscriber_callable: Callable
var _event_type
var _event_filters: Array

# object constructor
func _init(subscriber: Object, event_type = Event, event_filters: Array = [], subscriber_callable = null):
	_subscriber = subscriber
	_event_type = event_type
	_event_filters = event_filters

	if _subscriber_callable:
		_subscriber_callable = subscriber_callable

# friendly name when printing object
func _to_string():
	return "EventSubscription"

func as_dict():
	return {
		"subscriber": _subscriber.to_string(),
		"subscriber_callable": _subscriber_callable,
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

func get_subscriber_callable():
	return _subscriber_callable
func set_subscriber_callable(callable: Callable):
	_subscriber_callable = callable

func add_event_filter(event_filter: EventFilter):
	_event_filters.append(event_filter)

func get_subscriber():
	return _subscriber
func get_event_type():
	return _event_type
func get_event_filters():
	return _event_filters

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

