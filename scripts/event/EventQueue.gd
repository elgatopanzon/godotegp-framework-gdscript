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
var _process_type: int = false

var _events: Array[Event]

# object constructor
func _init(name = "unnamed", process_type: int = 0):
	set_queue_name(name)

	_process_type = process_type

func set_queue_name(name):
	_name = name
func get_queue_name():
	return _name

func get_process_type():
	return _process_type

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

	logger().debug("Adding event to queue", "event", {"event": event, "data": event.to_dict()})

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

		event.set_consumed(true)
		logger().debug("Event processed from queue", "event", {"event": event.to_dict(), "consumed": event.get_consumed()})

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
	
	logger().debug("Event filter match result", "result", {"matches": matches, "filters": event_filters})

	return matches

# process the queue with a list of EventSubscriptions
func process_queue(subscriptions: Array[EventSubscription] = []):
	if self._events.size() == 0:
		return false

	logger().debug("Processing event queue", "event_count", _events.size())

	# fetch all events from queue, no filters
	var events = fetch(Event, [], 0)

	var broadcast_queue = []

	# loop over all events and look for matching subscriptions
	for event in events:
		for subscription in subscriptions:
			if not event.is_valid():
				logger().debug("Event is consumed, discarding", "event", event.to_dict())
				continue

			# include base type filter from event type
			var event_filters = [EventFilterType.new(subscription.get_event_type())] + subscription.get_event_filters()

			# if the event matches a subscriptions filter, ship it!
			if event_matches_filters(event, event_filters):
				event.set_consumed(true)

				broadcast_queue.append([event, subscription])
				logger().debug("Queuing broadcast", "broadcast", {"event": event.to_dict(), "subscription": subscription.to_dict()})

		logger().debug("Event processed from queue", "event", {"event": event.to_dict(), "consumed": event.get_consumed()})

	for broadcast in broadcast_queue:
		broadcast_event(broadcast[0], broadcast[1])

# broadcast an event to an EventSubscription
func broadcast_event(event: Event, subscription: EventSubscription):
	var event_type = event.to_string()
	logger().debug("Broadcasting %s to subscriber" % event_type, "data", {"event": event.to_dict(), "subscription": subscription.to_dict()})

	var callables = []

	# add custom callable if exists
	var subscriber_callable = subscription.get_subscriber_callable()
	if subscriber_callable:
		callables.append(subscriber_callable)

	# create callable based on event and subscription filters
	# var method_string = "_on_%s" % [event_type]

	var method_string_parts = []

	method_string_parts.append(event.get_broadcast_method_string())

	for event_filter in subscription._event_filters:
		if event_filter.has_method("get_broadcast_method_string"):
			var filter_method_string = event_filter.get_broadcast_method_string()
			if filter_method_string:
				method_string_parts.append(filter_method_string)

	var method_string = "_on_%s" % ["__".join(method_string_parts)]

	var callable = Callable(subscription.get_subscriber(), method_string)

	# add automatic callable if no custom callable exists
	if callables.size() == 0:
		callables.append(callable)

	# call all callables
	for c in callables:
		logger().debug("Method string for Callable", "method_string", c.get_method())
		if subscription.get_subscriber().has_method(c.get_method()):
			c.call(event)
		else:
			logger().warning("Subscriber has no method %s" % [c.get_method()], "subscriber", subscription.get_subscriber())
