######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerDestination
# @created     : Friday Sep 08, 2023 22:33:46 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base class to implement a logging destination, used by Logger instances
######################################################################

class_name LoggerDestination
extends Node

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

# most basic implementation is writing to the console
func write(name, level: String, value, data = null):
	basic_write_to_console(name, level, value, data)

# function to write basic data to console without using LoggerTextBlock
func basic_write_to_console(name, level, value, data):
	if level in ['error', 'critical']:
		printerr("%s [%s]: %s (%s)" % [name, level, value, data])
	else:
		print("%s [%s]: %s (%s)" % [name, level, value, data])
