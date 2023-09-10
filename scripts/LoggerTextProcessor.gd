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

# object constructor
func _init():
	pass

func init(logger_destination_owner: LoggerDestination):
	_logger_destination_owner = logger_destination_owner

	return self

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
func pre_process(value):
	return value

# post-process function
func post_process(value):
	return value

# main process function
func process(value):
	return value

# called by the LoggerDestination to run the process chain
func process_value(value):
	return pre_process(process(post_process(value)))
