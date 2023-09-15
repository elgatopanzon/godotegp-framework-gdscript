######################################################################
# @author      : ElGatoPanzon
# @class       : EventError
# @created     : Thursday Sep 14, 2023 22:42:30 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Event to handles errors that occurred
######################################################################

class_name EventError
extends Event

var _error_type: String
var _error_data: Dictionary

# object constructor
func _init(type: String, data: Dictionary):
	_error_type = type
	_error_data = data

func init():
	return self

func get_type():
	return _error_type
func get_data():
	return _error_data

# friendly name when printing object
func _to_string():
	return "EventError"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass
