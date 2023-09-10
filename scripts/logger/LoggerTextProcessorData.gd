######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextProcessorData
# @created     : Saturday Sep 09, 2023 22:16:29 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Format the data output of the logger
######################################################################

class_name LoggerTextProcessorData
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

func process(value, value_original):
	if self._logger_line_current > 1:
		return ""

	var data_name = ""
	var data_value = ""
	if typeof(value_original) == TYPE_ARRAY:
		if len(value_original) == 2:
			data_name = value_original[0]
			data_value = value_original[1]

	if data_name:
		return "[color=cyan]%s[/color][color=gray]=[/color][color=pink]%s[/color]" % [data_name, data_value]

	elif value_original == null:
		return ""
	else:
		return value
