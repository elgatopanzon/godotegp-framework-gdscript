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
# func _process(delta: float):
# 	pass

# called during physics processing
# func _physics_process(delta: float):
# 	pass


# register a Service object
func register_service(service: Service, service_name: String):
	_services[service_name] = service

	add_child(service)

	# call on_registered handler
	service.on_registered()

	# emit signal
	emit_signal("service_registered", service)

# deregister a service from the ServiceManager
func deregister_service(service_name):
	var service = self.get_service(service_name)

	if service:
		_services.erase(service_name)

		# call on_deregistered handler
		service.on_deregistered()

		# emit signal
		emit_signal("service_deregistered", service)

# get a registered service
func get_service(service_name: String):
	return _services.get(service_name, null)

# wraper to use property names for accessing services
func _get(service_name):
	return get_service(service_name)
