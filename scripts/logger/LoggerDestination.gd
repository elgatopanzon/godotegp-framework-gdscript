######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerDestination
# @created     : Friday Sep 08, 2023 22:33:46 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base class to implement a logging destination, used by Logger instances
######################################################################

class_name LoggerDestination
extends Node

# hold registered text blocks
var _text_blocks: Array[LoggerTextBlock]

# hold current line info
var _line_time
var _line_name
var _line_level
var _line_value
var _line_data

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

# most basic implementation is writing to the console
func write(time, name, level: String, value, data_name = null, data = null):
	# support array of 2 components (name + data) or single variable dump
	if data != null:
		data = [data_name, data]
	else:
		data = data_name

	set_current_line_data(time, name, level, value, data)

	write_rendered()

# set current line data
func set_current_line_data(time, name, level, value, data):
	_line_time = time
	_line_name = name
	_line_level = level
	_line_value = value
	_line_data = data

# function to write a rendered line to destination
func write_rendered():
	basic_write_to_console()

# function to write basic data to console without using LoggerTextBlock
func basic_write_to_console():
	var line_formatted = "%s [%s]: %s (%s)" % [_line_name, _line_level, _line_value, _line_data]
	if _line_level in ['warning', 'error', 'critical']:
		if _line_level == "warning":
			push_warning(line_formatted)
		else:
			push_error(line_formatted)
	else:
		print(line_formatted)

# register a LoggerTextBlock instance for a data value
func register_text_block(text_block: LoggerTextBlock):
	if not text_block in _text_blocks:
		_text_blocks.append(text_block)

# dummy function, basic implementation doesn't use LoggerTextBlock
func setup_default_text_blocks():
	pass

# render text blocks and return array of strings
func get_rendered_text_blocks():
	var rendered_text_lines = []

	var separate_text_block_string = ""
	while true:
		var rendered_text_blocks = []

		var text_blocks_last_line_counter = 0

		for text_block in _text_blocks:
			# reset textblock when there's no currently rendered lines
			if len(rendered_text_lines) == 0:
				text_block.reinit()

			# set value of text block
			if text_block._type == "timestamp":
				text_block.set_value("")
			elif text_block._type == "name":
				text_block.set_value(_line_name)
			elif text_block._type == "level":
				text_block.set_value(_line_level)
			elif text_block._type == "value":
				text_block.set_value(_line_value)
			elif text_block._type == "data":
				text_block.set_value(_line_data)

				if not _line_data or text_block._line_current >= 1:
					continue
			elif text_block._type == "end":
				text_block.set_value("")

			elif text_block._type == "separator":
				separate_text_block_string = " | "
				for text_processor in text_block._text_processors:
					separate_text_block_string = text_processor.process_value(separate_text_block_string, separate_text_block_string)
				continue

			# render the text block
			rendered_text_blocks.append(text_block.render())

			if not text_block.is_last_line():
				text_blocks_last_line_counter += 1

		# use the first text block as separater
		var separate_text_block = _text_blocks[0]

		rendered_text_lines.append(separate_text_block_string.join(rendered_text_blocks))

		if text_blocks_last_line_counter == 0:
			break

	return rendered_text_lines
