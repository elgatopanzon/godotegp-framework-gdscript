######################################################################
# @author      : ElGatoPanzon
# @class       : ServiceManager
# @created     : Friday Sep 08, 2023 17:13:25 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Implementation of the Service Locator pattern
######################################################################

class_name ServiceManager
extends Node

signal service_registered(service)
signal service_deregistered(service)

var _services: Dictionary
var _services_ready: bool = false

var _call_queue: Dictionary

# object constructor
func _init():
	pass

# scene lifecycle methods
# called when node enters the tree
# func _enter_tree():
# 	pass

# called once when node is ready
# func _ready():
# 	pass

# called when node exits the tree
# func _exit_tree():
# 	pass


# process methods
# called during main loop processing
func _process(delta: float):
	if not services_ready():
		var ready_count = 0

		for service in _services:
			var s = _services[service]

			if s.get_ready():
				ready_count += 1

		if ready_count == _services.size():
			set_services_ready(true)

# called during physics processing
# func _physics_process(delta: float):
# 	pass

func services_ready():
	return _services_ready
func set_services_ready(state: bool = true):
	_services_ready = state

	# emit event informing listeners when all services are ready
	Services.Events.emit_now(EventServicesReady.new())

# register a Service object
func register_service(service: Service, service_name: String):
	_services[service_name] = service

	add_child(service)

	# emit signal
	emit_signal("service_registered", service)

	Services.register_delayed_service_call("Events", Callable(func(): Services.Events.emit_now(EventServiceRegistered.new(self, service_name))))

	# perform any delayed calls
	execute_delayed_service_calls(service_name)

	# call on_registered handler
	service.on_registered()


# deregister a service from the ServiceManager
func deregister_service(service_name):
	var service = self.get_service(service_name)

	if service:
		_services.erase(service_name)

		# call on_deregistered handler
		service.on_deregistered()

		# emit signal
		emit_signal("service_deregistered", service)

		Services.register_delayed_service_call("Events", Callable(func(): Services.Events.emit_now(EventServiceDeregistered.new(self, service_name))))

# get a registered service
func get_service(service_name: String):
	return _services.get(service_name, null)

# wraper to use property names for accessing services
func _get(service_name):
	return get_service(service_name)

# queue a deferred call to a service to make upon it being registered
func register_delayed_service_call(service_name: String, callable: Callable, params: Array = []):
	if not _call_queue.get(service_name, null):
		_call_queue[service_name] = []

	_call_queue[service_name].append({"callable": callable, "params": params})

	execute_delayed_service_calls(service_name)

# execute delayed service registered calls
func execute_delayed_service_calls(service_name: String):
	# if the service is available, execute the delayed call
	if get_service(service_name):
		var calls = _call_queue.get(service_name, [])

		while true:
			var call = calls.pop_front()

			if not call:
				break

			var callable = call.callable

			for p in call.params:
				callable.bind(p)

			callable.call()

# check if a service is ready yet
func service_ready(service_name: String):
	if get_service(service_name):
		return get_service(service_name).get_ready()
