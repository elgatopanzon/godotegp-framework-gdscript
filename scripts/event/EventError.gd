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

var _error_owner: Object
var _error_type: String
var _error_data

# object constructor
func _init(owner: Object, type: String, data = null):
	_error_owner = owner
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

func to_dict():
	return {
		"owner": _error_owner,
		"type": _error_type,
		"data": _error_data,
	}
