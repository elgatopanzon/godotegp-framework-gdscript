######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextProcessor
# @created     : Saturday Sep 09, 2023 19:07:01 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base class to perform processing on logged strings
######################################################################

class_name LoggerTextProcessor
extends Node

var _logger_destination_owner: LoggerDestination

var _logger_line_current: int

# object constructor
func _init():
	pass

func init(logger_destination_owner: LoggerDestination):
	_logger_destination_owner = logger_destination_owner

	return self

func set_current_line(line_no):
	_logger_line_current = line_no

func get_destination_owner():
	return _logger_destination_owner

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

# pre-process function
func pre_process(value, value_original):
	return value

# post-process function
func post_process(value, value_original):
	return value

# main process function
func process(value, value_original):
	return value

# called by the LoggerDestination to run the process chain
func process_value(value, value_original):
	return pre_process(process(post_process(value, value_original), value_original), value_original)
