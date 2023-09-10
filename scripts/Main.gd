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

# object constructor
func _init():
	# init and register services
	# object pool
	Services.register_service(ObjectPoolService.new(), "ObjectPool")

	# logging
	Services.register_service(LoggerService.new(), "Log")
	Services.Log.set_default_log_level("debug")

	# create console logger
	var logger_console = Logger.new()
	var logger_destination_console = LoggerDestinationConsole.new()
	logger_console.add_destination(logger_destination_console)

	# add all the default LoggerTextBlocks for this type of destination
	logger_destination_console.setup_default_text_blocks()


	# logging test using self as group
	Services.Log.register_logger(logger_console, self)
	Services.Log.get(self).set_level("debug")

	Services.Log.get(self).debug("log test debug")
	Services.Log.get(self).info("log test info but a really longgg message so I can try to split it by word", ["varname", {"test_key": "test_value"}])
	Services.Log.get(self).warning("log test warning")
	Services.Log.get(self).error("log test error")
	Services.Log.get(self).critical("log test critical", ["bigdict", {"some_fairly_large_dict": "value", "another_val": 123}])

	var node_test = Node2D.new()
	Services.Log.register_logger(logger_console, node_test)
	Services.Log.get(node_test).set_level("debug")
	Services.Log.get(node_test).debug("log test debug")

	Services.Log.register_logger(logger_console, "Test")
	Services.Log.Test.debug("log test debug")


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

