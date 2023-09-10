######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextProcessorBold
# @created     : Saturday Sep 09, 2023 20:02:09 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Bolded text
######################################################################

class_name LoggerTextProcessorBold
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

func process(value):
	return "[b]%s[/b]" % [value]
