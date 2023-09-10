######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextProcessorLineColorFromLevel
# @created     : Saturday Sep 09, 2023 19:08:50 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Apply a colour based on the log level
######################################################################

class_name LoggerTextProcessorLineColorFromLevel
extends LoggerTextProcessor

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

# apply bbcode colour based on log level from parent LoggerDestination
func process(value, value_original):
	var bgcolor = ""
	var fgcolor = ""

	match _logger_destination_owner._line_level:
		"debug":
			bgcolor = "black"
			fgcolor = "green"
		"info":
			bgcolor = "cyan"
			fgcolor = "black"
		"warning":
			bgcolor = "orange"
			fgcolor = "black"
		"error":
			bgcolor = "red"
			fgcolor = "white"
		"critical":
			bgcolor = "red"
			fgcolor = "white"

	return "[bgcolor=%s][color=%s]%s[/color][/bgcolor]" % [bgcolor, fgcolor, value]
