######################################################################
# @author      : ElGatoPanzon
# @class       : EventQueue
# @created     : Sunday Sep 10, 2023 17:20:29 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Hold and manage a queue of Event objects
######################################################################

class_name EventQueue
extends Node

var _name

var _events: Array[Event]

# object constructor
func _init(name = "unnamed"):
	set_queue_name(name)

func set_queue_name(name):
	_name = name

func init():
	return self

# used by LoggerService
func _to_string():
	return "EventQueue [%s]" % [_name]

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

func queue(event: Event, single_consume: bool = false):
	logger().debug("Adding event to queue", "event", event)

	event.set_single_consume(single_consume)
	_events.append(event)

# return a single event from the queue
func fetch(event_filters: Array = [], count: int = 1):
	# matching events
	var matches = []

	for event_idx in _events.size():
		var event_matches = event_matches_filters(_events[event_idx], event_filters)

		if not event_matches:
			continue

		matches.append(_events.pop_at(event_idx))

		if matches.size() >= count and count > 0:
			break

	return matches

# check if an event matches filters
func event_matches_filters(event: Event, event_filters: Array = []):
	var matches = true

	for filter in event_filters:
		if not filter.match(event):
			matches = false
			break

	return matches
