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
var _is_deffered: bool = false

var _events: Array[Event]

# object constructor
func _init(name = "unnamed", is_deffered: bool = false):
	set_queue_name(name)

	_is_deffered = is_deffered

func set_queue_name(name):
	_name = name
func get_queue_name():
	return _name

func is_deffered():
	return _is_deffered

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
	event.set_single_consume(single_consume)

	logger().debug("Adding event to queue", "event_type", event)
	logger().debug("...", "event", event.as_dict())

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

# process the queue with a list of EventSubscriptions
func process_queue(subscriptions: Array[EventSubscription] = []):
	if self._events.size() == 0:
		return false

	logger().debug("Processing event queue", "event_count", _events.size())

	# fetch all events from queue, no filters
	var events = fetch(Event, [], 0)

	# loop over all events and look for matching subscriptions
	for event in events:
		for subscription in subscriptions:
			if not event.is_valid():
				logger().debug("Event is consumed, discarding", "event", event.as_dict())
				continue

			# include base type filter from event type
			var event_filters = [EventFilterType.new(subscription.get_event_type())] + subscription.get_event_filters()

			# if the event matches a subscriptions filter, ship it!
			if event_matches_filters(event, event_filters):
				event.set_consumed(true)

				broadcast_event(event, subscription)

# broadcast an event to an EventSubscription
func broadcast_event(event: Event, subscription: EventSubscription):
	var event_type = event.to_string()
	logger().debug("Broadcasting %s to subscriber" % event_type, "event", event.as_dict())
	logger().debug("...", "subscription", subscription.as_dict())
	
	var method_string = "_on_%s" % [event_type]

	if subscription.get_subscriber().has_method(method_string):
		var callable = Callable(subscription.get_subscriber(), method_string)
		callable.call(event)
	else:
		logger().error("Subscriber has no method %s" % [method_string], "subscriber", subscription.get_subscriber())
