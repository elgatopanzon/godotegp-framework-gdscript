######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextProcessorColor
# @created     : Saturday Sep 09, 2023 22:02:36 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Format text with a specific bbcode color
######################################################################

class_name LoggerTextProcessorColor
extends LoggerTextProcessor

var _color: String = "white"
var _multiline_drop_color: bool = true

# object constructor
func _init():
	pass

func set_color(color: String, multiline_drop_color: bool = true):
	_color = color

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

func get_color():
	if self._logger_line_current > 1 and not _multiline_drop_color:
		return "black"
	else:
		return _color

func process(value, value_original):
	return "[color=%s]%s[/color]" % [get_color(), value]
