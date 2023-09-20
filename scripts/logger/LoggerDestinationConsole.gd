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

func _to_string():
	return "LoggerDestination"

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
	_text_blocks = []

	var processor_line_from_level = LoggerTextProcessorLineColorFromLevel.new().init(self)
	var processor_log_level = LoggerTextProcessorLogLevel.new().init(self)
	var processor_bold = LoggerTextProcessorBold.new().init(self)
	var processor_pad = LoggerTextProcessorPad.new().init(self)

	register_text_block(LoggerTextBlock.new().init("separator", 0, [
		processor_line_from_level
		]))

	register_text_block(LoggerTextBlock.new().init("timestamp", config().padding_timestamp, [
		LoggerTextProcessorTimestamp.new().init(self),
		LoggerTextProcessorPad.new().init(self).set_pad(config().padding_timestamp),
		LoggerTextProcessorColor.new().init(self).set_color(config().color_timestamp),
		processor_line_from_level,
		]))
	register_text_block(LoggerTextBlock.new().init("name", config().padding_name, [
		LoggerTextProcessorName.new().init(self),
		LoggerTextProcessorPad.new().init(self).set_pad(config().padding_name),
		LoggerTextProcessorColor.new().init(self).set_color(config().color_name, false),
		processor_line_from_level,
		]))

	register_text_block(LoggerTextBlock.new().init("level", config().padding_log_level, [
		LoggerTextProcessorPad.new().init(self).set_pad(config().padding_log_level),
		processor_log_level,
		processor_line_from_level,
		processor_bold,
		]))

	register_text_block(LoggerTextBlock.new().init("value", config().padding_message, [
		LoggerTextProcessorPad.new().init(self).set_pad(config().padding_message),
		LoggerTextProcessorColor.new().init(self).set_color(config().color_message, false),
		processor_line_from_level,
		]))
	register_text_block(LoggerTextBlock.new().init("data", config().padding_data, [
		LoggerTextProcessorPad.new().init(self).set_pad(config().padding_data),
		# LoggerTextProcessorData.new().init(self),
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

func config():
	if _config:
		return _config.logger_console
	else:
		return DataResourceConfigEngine.new().data_from_schema().logger_console # gets all default values
