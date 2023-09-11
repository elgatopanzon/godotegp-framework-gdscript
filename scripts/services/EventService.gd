######################################################################
# @author      : ElGatoPanzon
# @class       : EventService
# @created     : Sunday Sep 10, 2023 16:19:27 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Manage EventQueue instances and provide easy interfaces
######################################################################

class_name EventService
extends ServiceManagerService

var _event_queues: Dictionary

var _subscriptions: Array[EventSubscription]

# object constructor
func _init():
	# register builtin event queues
	register_queue(EventQueue.new("instant", 1))
	register_queue(EventQueue.new("deferred", 2))
	register_queue(EventQueue.new("fetch", 0))

func init():
	return self

# used by LoggerService
func _to_string():
	return "EventService"

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
func _process(delta: float):
	for event_queue in _event_queues:
		var queue = _event_queues[event_queue]

		# only process queues which have deferred processing enabled
		if queue.get_process_type() == 2:
			process_queue(queue)

# called during physics processing
# func _physics_process(delta: float):
#	pass

# register an event queue
func register_queue(event_queue: EventQueue):
	var queue_name = event_queue.get_queue_name()

	if not _event_queues.get(queue_name, null):
		logger().debug("Registering event queue", "event_queue", queue_name)

		_event_queues[queue_name] = event_queue

		return true
	else:
		logger().debug("Event queue already registered", "event_queue", queue_name)

		return false

# get an event queue
func get_queue(queue_name):
	return _event_queues.get(queue_name, null)
func get(queue_name):
	return get_queue(queue_name)
func _get(queue_name):
	return get_queue(queue_name)

# shortcuts to get builtin queues
func get_instant_queue():
	return get_queue("instant")
func get_deferred_queue():
	return get_queue("deferred")
func get_fetch_queue():
	return get_queue("fetch")


# allow object to subscribe Events emitted by emit() and emit_now()
func subscribe(subscription: EventSubscription):
	logger().debug("Registering EventSubscription", "subscription", subscription.as_dict())

	_subscriptions.append(subscription)

# allow unsubscribing from events
func unsubscribe(subscriber: Object, event_type = Event):
	var unsubscribes = []

	for subscription in _subscriptions:
		if subscription.get_subscriber() == subscriber and (subscription.get_event_type() == event_type or event_type == Event):
			logger().debug("Unsubscribing from events", "unsubscription", {"subscriber": subscription.as_dict()['subscriber'], "event_type": subscription.as_dict()['event_type']})

			unsubscribes.append(subscription)

	# remove any matching subscriptions
	for unsubscribe in unsubscribes:
		_subscriptions.erase(unsubscribe)


func subscribe_signal(connect_object: Object, signal_name: String, subscription: EventSubscription):
	logger().debug("Registering signal EventSubscription", "subscription", subscription.as_dict())
	logger().debug("...", "object", connect_object)
	logger().debug("...", "signal", signal_name)

	# connect to the object with the given signal
	connect_object.connect(signal_name, Callable(self, "_on_signal").bind({"object": connect_object, "name": signal_name, "subscription": subscription}))

	# add the subscription to the system
	# add filter for EventSignal events
	subscription.add_event_filter(EventFilterType.new(EventSignal))
	subscription.add_event_filter(EventFilterCustom.new(Callable(func(event): return event._signal_name == signal_name)))
	subscription.add_event_filter(EventFilterObject.new(connect_object))

	# add custom Callable to pass event to
	subscription.set_subscriber_callable(Callable(subscription.get_subscriber(), "_on_EventSignal_%s" % [signal_name]))

	# register the subscription
	subscribe(subscription)

func _on_signal(signal_data: Dictionary, signal_param = null):
	logger().debug("Signal received from node", "signal_data", signal_data)
	logger().debug("...", "signal_param", signal_param)

	emit_now(EventSignal.new(signal_data.object, signal_data.name, signal_param))

# emit an event to the deferred queue, to be processed in _process()
func emit(event: Event, queue_name = "deferred"):
	logger().debug("Event emit(%s)" % event, "event", event.as_dict())

	get_queue(queue_name).queue(event, false)

# emit an event to the instant broadcast queue
func emit_now(event: Event, queue_name = "instant"):
	logger().debug("Event emit_now(%s)" % event, "event", event.as_dict())

	get_queue(queue_name).queue(event, false)

	process_queue(get_queue(queue_name))

# emit an event to the deferred queue, but only consumed once
func emit_once(event: Event, queue_name = "deferred"):
	logger().debug("Event emit_once(%s)" % event, "event", event.as_dict())
	
	get_queue(queue_name).queue(event, true)

# emit an event to the instant broadcast queue, but only consumed once
func emit_now_once(event: Event, queue_name = "instant"):
	logger().debug("Event emit_now_once(%s)" % event, "event", event.as_dict())

	get_queue(queue_name).queue(event, true)

	process_queue(get_queue(queue_name))

# emit an event to the wait queue, to be fetched later
func emit_wait(event: Event, queue_name = "fetch"):
	logger().debug("Event emit_wait(%s)" % event, "event", event.as_dict())

	get_queue(queue_name).queue(event, true)


# process an event queue and dispatch events to subscribers
func process_queue(event_queue):
	event_queue.process_queue(_subscriptions)

# fetch all (and remove) events from wait queue matching event type
func fetch_all(event_type = Event, event_filters: Array = []):
	return fetch(event_type, event_filters, 0)

# fetch X (and remove) events from wait queue matching event type
func fetch(event_type = Event, event_filters: Array = [], count: int = 1):
	return get_fetch_queue().fetch(event_type, event_filters, count)
