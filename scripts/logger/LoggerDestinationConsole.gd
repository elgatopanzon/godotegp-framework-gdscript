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
	var processor_line_from_level = LoggerTextProcessorLineColorFromLevel.new().init(self)
	var processor_log_level = LoggerTextProcessorLogLevel.new().init(self)
	var processor_bold = LoggerTextProcessorBold.new().init(self)
	var processor_pad = LoggerTextProcessorPad.new().init(self)

	register_text_block(LoggerTextBlock.new().init("separator", 0, [
		processor_line_from_level
		]))

	register_text_block(LoggerTextBlock.new().init("timestamp", 30, [
		LoggerTextProcessorTimestamp.new().init(self),
		LoggerTextProcessorPad.new().init(self).set_pad(30),
		LoggerTextProcessorColor.new().init(self).set_color("gray"),
		processor_line_from_level,
		]))
	register_text_block(LoggerTextBlock.new().init("name", 25, [
		LoggerTextProcessorName.new().init(self),
		LoggerTextProcessorPad.new().init(self).set_pad(25),
		LoggerTextProcessorColor.new().init(self).set_color("orange", false),
		processor_line_from_level,
		]))

	register_text_block(LoggerTextBlock.new().init("level", 10, [
		LoggerTextProcessorPad.new().init(self).set_pad(10),
		processor_log_level,
		processor_line_from_level,
		processor_bold,
		]))

	register_text_block(LoggerTextBlock.new().init("value", 40, [
		LoggerTextProcessorPad.new().init(self).set_pad(40),
		LoggerTextProcessorColor.new().init(self).set_color("white", false),
		processor_line_from_level,
		]))
	register_text_block(LoggerTextBlock.new().init("data", 0, [
		LoggerTextProcessorPad.new().init(self).set_pad(0),
		LoggerTextProcessorData.new().init(self),
		processor_line_from_level,
		]))

	register_text_block(LoggerTextBlock.new().init("end", 0))

# write to console using LoggerTextBlocks rendering
func write_rendered():
	var rendered_lines = get_rendered_text_blocks()

	for line in rendered_lines:
		print_rich(line)

		if _line_level in ['warning', 'error', 'critical']:
			basic_write_to_console()