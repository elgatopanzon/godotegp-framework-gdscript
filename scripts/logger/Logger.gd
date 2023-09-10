######################################################################
# @author      : ElGatoPanzon
# @class       : Logger
# @created     : Friday Sep 08, 2023 22:22:51 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Handle logging to multiple LoggerDestination objects
######################################################################

class_name Logger
extends Node

var _logger_destinations: Array[LoggerDestination]

# object constructor
func _init():
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

# log data to configured destinations
# name: (like a module or class name)
# level: (severity of the log)
# value: (the text or item to log)
# data: (any attached data dump)
func log(name, level: String, value, data_name = null, data = null):
	for logger_destination in _logger_destinations:
		logger_destination.write(name, level, value, data_name, data)

# add LoggerDestination object
func add_destination(logger_destination: LoggerDestination):
	_logger_destinations.append(logger_destination)
