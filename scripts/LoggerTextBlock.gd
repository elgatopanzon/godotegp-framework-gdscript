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

# object constructor
func _init():
	pass

func init(type: String, line_length: int = 10):
	_type = type
	_line_length = line_length

	return self

# called by ObjectPool after instantiate
func prepare():
	pass

# called by ObjectPool to reset object for reuse
func request_ready():
	_type = ""
	_value = null
	_line_length = 10

func set_value(value):
	request_ready()
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
	return value_as_padded_string()

func value_as_padded_string():
	return self.value_as_string().rpad(_line_length)
