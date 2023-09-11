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

# return events from the queue
func fetch(event_type = Event, event_filters: Array = [], count: int = 1):
	# matching events
	var matches: Array[Event] = []
	var non_matches: Array[Event] = []

	# create EventFilterType filter
	event_filters.push_front(EventFilterType.new(event_type))

	while (matches.size() < count and count > 0) or count == 0:
		# take an event off the stack
		var event = _events.pop_front()

		# if there's none
		if not event:
			break

		var event_matches = event_matches_filters(event, event_filters)

		# return the event if it doesn't match
		if not event_matches:
			non_matches.push_back(event)
			continue

		matches.append(event)

	# return non_matched events to queue
	_events = non_matches + _events

	return matches

# check if an event matches filters
func event_matches_filters(event: Event, event_filters: Array = []):
	var matches = true

	for filter in event_filters:
		if not filter.match(event):
			matches = false
			break

	return matches
