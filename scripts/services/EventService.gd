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
	register_queue("instant", EventQueue.new())
	register_queue("deferred", EventQueue.new())
	register_queue("fetch", EventQueue.new())

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
		if event_queue not in ['fetch', 'instant']:
			process_queue(_event_queues[event_queue])

# called during physics processing
# func _physics_process(delta: float):
#	pass

# register an event queue
func register_queue(queue_name, event_queue: EventQueue):
	if not _event_queues.get(queue_name, null):
		logger().debug("Registering event queue", "event_queue", queue_name)

		event_queue.set_queue_name(queue_name)
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


# emit an event to the deferred queue, to be processed in _process()
func emit(event: Event):
	logger().debug("Event emit(%s)" % event, "event", event.as_dict())

	get_deferred_queue().queue(event, false)

# emit an event to the instant broadcast queue
func emit_now(event: Event):
	logger().debug("Event emit_now(%s)" % event, "event", event.as_dict())

	get_instant_queue().queue(event, false)

	process_queue(get_instant_queue())

# emit an event to the deferred queue, but only consumed once
func emit_once(event: Event):
	logger().debug("Event emit_once(%s)" % event, "event", event.as_dict())
	
	get_instant_queue().queue(event, true)

# emit an event to the instant broadcast queue, but only consumed once
func emit_now_once(event: Event):
	logger().debug("Event emit_now_once(%s)" % event, "event", event.as_dict())

	get_instant_queue().queue(event, true)

	process_queue(get_instant_queue())

# emit an event to the wait queue, to be fetched later
func emit_wait(event: Event):
	logger().debug("Event emit_wait(%s)" % event, "event", event.as_dict())

	get_fetch_queue().queue(event, true)


# process an event queue and dispatch events to subscribers
func process_queue(event_queue):
	event_queue.process_queue(_subscriptions)

# fetch all (and remove) events from wait queue matching event type
func fetch_all(event_type = Event, event_filters: Array = []):
	return fetch(event_type, event_filters, 0)

# fetch X (and remove) events from wait queue matching event type
func fetch(event_type = Event, event_filters: Array = [], count: int = 1):
	return get_fetch_queue().fetch(event_type, event_filters, count)
