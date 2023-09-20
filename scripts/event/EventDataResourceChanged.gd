######################################################################
# @author      : ElGatoPanzon
# @class       : EventDataResourceChanged
# @created     : Wednesday Sep 20, 2023 13:55:42 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Event emitted when a DataResource object has changed data
######################################################################

class_name EventDataResourceChanged
extends Event

var _owner

# object constructor
func _init(owner: DataResource):
	_owner = owner
	pass

func init():
	return self

func get_owner():
	return _owner

func to_dict():
	return { "owner": _owner }

# friendly name when printing object
func _to_string():
	return "EventDataResourceChanged"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass
