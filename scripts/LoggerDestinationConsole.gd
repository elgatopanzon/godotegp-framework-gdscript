######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerDestinationConsole
# @created     : Saturday Sep 09, 2023 15:14:20 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Use LoggerTextBlock instances to write to the console
######################################################################

class_name LoggerDestinationConsole
extends LoggerDestination

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

# setup instances of LoggerTextBlock for console output
func setup_default_text_blocks():
	register_text_block(LoggerTextBlock.new().init("timestamp", 20))
	register_text_block(LoggerTextBlock.new().init("name", 10))
	register_text_block(LoggerTextBlock.new().init("level", 8))
	register_text_block(LoggerTextBlock.new().init("value", 40))
	register_text_block(LoggerTextBlock.new().init("data", 40))

# write to console using LoggerTextBlocks rendering
func write_rendered():
	var rendered_lines = get_rendered_text_blocks()

	print_rich(rendered_lines)
