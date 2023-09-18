######################################################################
# @author      : ElGatoPanzon
# @class       : Result
# @created     : Friday Sep 15, 2023 18:58:55 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Holds enhanced information about the execution of a method
######################################################################

class_name Result
extends RefCounted

var _return_value
var _error: ResultError

# object constructor
func _init(return_value, error = null):
	_return_value = return_value
	
	if error:
		_error = error

func init():
	return self

func get_error():
	return _error
func get_value():
	return _return_value

# friendly name when printing object
func _to_string():
	return "Result"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

func _get(prop):
	if prop == "SUCCESS":
		return (_error == null)
	if prop == "FAILED":
		return (_error != null)
	if prop == "error":
		return _error
	if prop == "value":
		return _return_value
