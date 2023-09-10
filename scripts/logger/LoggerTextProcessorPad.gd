######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextProcessorPad
# @created     : Saturday Sep 09, 2023 20:17:34 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Pad output based on set value 
######################################################################

class_name LoggerTextProcessorPad
extends LoggerTextProcessor

var _pad: int = 0

# object constructor
func _init():
	pass

func set_pad(value: int = 0):
	_pad = value

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
	if _pad > 0:
		return value.rpad(_pad)
	else:
		return value
