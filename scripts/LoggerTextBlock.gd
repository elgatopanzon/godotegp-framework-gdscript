######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextBlock
# @created     : Saturday Sep 09, 2023 14:59:42 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Handles accepting variables and rendering the result back
######################################################################

class_name LoggerTextBlock
extends Node

var _type: String
var _value

var _line_length: int
var _line_current: int = 0
var _line_strings: Dictionary

var _text_processors: Array[LoggerTextProcessor]

# object constructor
func _init():
	pass

func init(type: String, line_length: int = 0, text_processors: Array[LoggerTextProcessor] = []):
	_type = type
	_line_length = line_length

	_text_processors = text_processors

	return self

func reinit():
	_line_current = 0
	_line_strings = {}

func set_value(value):
	_value = value

	if _line_length:
		_line_strings = get_line_text()

func set_type(type: String):
	_type = type

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

# get the value as a string
func value_as_string():
	return "%s" % [_value]

# pre-render the value before processing
func pre_render():
	var pre_rendered = value_as_string()
	
	if _line_length > 0:
		pre_rendered = get_next_line()

	# apply type-based pre_renders
	if _type == "level":
		pre_rendered = pre_rendered.to_upper()

	return pre_rendered

func render():
	var rendered = pre_render()

	for text_processor in _text_processors:
		rendered = text_processor.process_value(rendered)

	return rendered

# return the value, but padded
func value_as_padded_string():
	return self.value_as_string().rpad(_line_length)

# return the next line of text
func get_next_line():
	var current_line_string = ""
	if _line_strings.get(_line_current, null):
		current_line_string = " ".join(_line_strings[_line_current])

	_line_current += 1

	return current_line_string

# check if current line is last
func is_last_line():
	if _line_length > 0:
		return _line_current > get_line_count()
	else:
		return true

# deprecated: return line count based on line length
func get_line_count():
	return len(value_as_string()) / _line_length

# return a dict with the key for each line of text to print
func get_line_text():
	var value_words = value_as_string().split(" ")
	var value_lines = {}

	var value_line_char_count = 0
	var value_line_line_count = 0
	var value_line_word_count = 0
	while value_line_word_count < len(value_words):
		var current_line_word = value_words[value_line_word_count]
		value_line_word_count += 1

		if not value_lines.get(value_line_line_count):
			value_lines[value_line_line_count] = []

		# if the single word is larger than the max, just put it as-is
		if len(current_line_word) > _line_length:
			value_lines[value_line_line_count].append(current_line_word)
			value_line_line_count += 1
			value_line_word_count += 1
			value_line_char_count = 0

			continue
		
		# if the next word will stick off the end, put it on the next line
		elif len(current_line_word) + value_line_char_count > _line_length:
			value_lines[value_line_line_count+1] = []
			value_lines[value_line_line_count+1].append(current_line_word)
			value_line_line_count += 1
			value_line_word_count += 1
			value_line_char_count = 0

			continue

		elif len(current_line_word) + value_line_char_count <= _line_length:
			value_lines[value_line_line_count].append(current_line_word)
			value_line_char_count += (len(current_line_word) + 1)


	return value_lines
