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
func write(name, level: String, value, data = null):
	set_current_line_data(name, level, value, data)

	write_rendered()

# set current line data
func set_current_line_data(name, level, value, data):
	_line_name = name
	_line_level = level
	_line_value = value
	_line_data = data

# function to write a rendered line to destination
func write_rendered():
	basic_write_to_console()

# function to write basic data to console without using LoggerTextBlock
func basic_write_to_console():
	if _line_level in ['error', 'critical']:
		printerr("%s [%s]: %s (%s)" % [_line_name, _line_level, _line_value, _line_data])
	else:
		print("%s [%s]: %s (%s)" % [_line_name, _line_level, _line_value, _line_data])

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

	while true:
		var rendered_text_blocks = []

		for text_block in _text_blocks:
			# reset text block
			text_block.request_ready()

			# set value of text block
			if text_block._type == "timestamp":
				text_block.set_value("timestamp")
			elif text_block._type == "name":
				text_block.set_value(_line_name)
			elif text_block._type == "level":
				text_block.set_value(_line_level)
			elif text_block._type == "value":
				text_block.set_value(_line_value)
			elif text_block._type == "data":
				text_block.set_value(_line_data)

			# render the text block
			rendered_text_blocks.append(text_block.render())

		rendered_text_lines.append(" | ".join(rendered_text_blocks))

		break

	return rendered_text_lines[0]
