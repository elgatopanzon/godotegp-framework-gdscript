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

# object constructor
func _init():
	pass

func init(type: String, line_length: int = 0):
	_type = type
	_line_length = line_length

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

# render the value, most basic implementation (return the value as-is)
func render():
	if _line_length > 0:
		return get_next_line()
	else:
		return value_as_padded_string()

func value_as_padded_string():
	return self.value_as_string().rpad(_line_length)

func get_next_line():
	var current_line_string = ""
	if _line_strings.get(_line_current, null):
		current_line_string = " ".join(_line_strings[_line_current])

	_line_current += 1

	return current_line_string.rpad(_line_length)

func is_last_line():
	if _line_length > 0:
		return _line_current > get_line_count()
	else:
		return true

func get_line_count():
	return len(value_as_string()) / _line_length

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