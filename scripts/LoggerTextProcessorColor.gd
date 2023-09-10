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

# object constructor
func _init():
	pass

func set_color(color: String):
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

func process(value, value_original):
	return "[color=%s]%s[/color]" % [_color, value]
