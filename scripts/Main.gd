######################################################################
# @author      : ElGatoPanzon
# @class       : Main
# @created     : Friday Sep 08, 2023 18:07:54 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Main script for controlling the framework
######################################################################

class_name GodotEGPFramework
extends Node

var _services: Dictionary = {
	"Log": LoggerService, # init first so other services can use it
	"Events": EventService,
	"System": SystemService,
	"ObjectPool": ObjectPoolService,
	"DataFS": DataServiceFS,
	"Data": DataService,
	"Config": ConfigService,
	"Random": RandomService,
	"Nodes": NodeService,
}

func to_string():
	return "GodotEGP.Main"

func logger():
	return Services.Log.get(self.to_string())


# object constructor
func _init():
	# connect signal to react on registered services
	Services.connect("service_registered", Callable(self, "_on_service_registered"))

	# init and register services
	for service in _services:
		Services.register_service(_services[service].new(), service)

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

# perform functionality on service being registered
func _on_service_registered(service: Service):
	if Services.get_service("Config") and Services.get_service("Log") and Services.get_service("System"):
		# set default log level from config if it doesn't match
		var log_level = Services.Config.ConfigEngine.get("logger").get("log_level_%s" % Services.System.build_type)

		if Services.Log.get_default_log_level() != log_level:
			logger().info("Setting log level from config", "level", log_level)

			Services.Log.set_default_log_level(log_level)
			Services.Log.set_log_level(log_level)
