######################################################################
# @author      : ElGatoPanzon
# @class       : ResultError
# @created     : Friday Sep 15, 2023 19:00:06 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Result object's accompanying Error object
######################################################################

class_name ResultError
extends RefCounted

var _error_owner: Object
var _error_type: String
var _error_message: String
var _error_data
var _child_errors: Array[ResultError]

# object constructor
func _init(owner: Object, type: String, data = null, message: String = ""):
	_error_owner = owner
	_error_type = type
	_error_message = message if message != "" else type
	_error_data = data

func init():
	return self

func add_error(error: ResultError):
	_child_errors.append(error)
func get_errors():
	return _child_errors

func get_type():
	return _error_type
func get_message():
	return _error_message
func get_data():
	return _error_data
func get_error_count():
	return _child_errors.size()

# friendly name when printing object
func _to_string():
	return "ResultError"

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
		"message": _error_message,
		"data": _error_data,
	}
