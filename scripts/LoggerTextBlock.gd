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

# object constructor
func _init():
	pass

func init(type: String, line_length: int = 10):
	_type = type
	_line_length = line_length

	return self

func reinit():
	_line_current = 0

func set_value(value):
	_value = value

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
	return get_next_line()

func value_as_padded_string():
	return self.value_as_string().rpad(_line_length)

func get_next_line():
	var current_line_start = (_line_current * _line_length)
	var current_line_string = self.value_as_string().substr(current_line_start, _line_length)

	_line_current += 1

	return current_line_string.rpad(_line_length)

func is_last_line():
	return _line_current > get_line_count()

func get_line_count():
	return len(value_as_string()) / _line_length
