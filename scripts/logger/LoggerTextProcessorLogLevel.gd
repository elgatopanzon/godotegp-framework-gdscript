######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextProcessorLogLevel
# @created     : Saturday Sep 09, 2023 20:43:01 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Apply processing based on log level
######################################################################

class_name LoggerTextProcessorLogLevel
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

# apply bbcode based on log level from parent LoggerDestination
func process(value, value_original):
	match _logger_destination_owner._line_level:
		"debug":
			value = "[color=green]%s[/color]" % [value]
		"info":
			value = "[color=green]%s[/color]" % [value]
		"warning":
			value = "[color=orange]%s[/color]" % [value]
		"error":
			value = "[color=red]%s[/color]" % [value]
		"critical":
			value = "[i][b][bgcolor=red][color=white]%s[/color][/bgcolor][/b][/i]" % [value.substr(0, len(value) - 1)]
			pass

	return value
