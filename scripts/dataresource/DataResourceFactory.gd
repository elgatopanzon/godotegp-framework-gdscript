######################################################################
# @author      : ElGatoPanzon
# @class       : DataResourceFactory
# @created     : Thursday Sep 21, 2023 18:27:01 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Provides object serialisation/deserialisation
######################################################################

class_name DataResourceFactory
extends Resource

const SUPPORTED_OBJECTS = {
	"vector2": FactoryVector2
}

var _object_type: String
var _data

# object constructor
func _init(object_type: String, data):
	_object_type = object_type
	_data = data

# friendly name when printing object
func _to_string():
	return "DataResourceFactory"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

# check if the current schema type is a supported object
func supported():
	return _object_type in SUPPORTED_OBJECTS

func get_factory_instance():
	return SUPPORTED_OBJECTS.get(_object_type).new()

func serialise():
	if supported():
		var r = get_factory_instance().serialise(_data)

		return r
	else:
		return Result.new(false, ResultError.new(self, "unsupported_object_factory"))

func deserialise():
	if supported():
		var r = get_factory_instance().deserialise(_data)

		return r
	else:
		return Result.new(false, ResultError.new(self, "unsupported_object_factory"))


# Vector2
class FactoryVector2:
	extends RefCounted

	func serialise(object):
		return Result.new({"x": object.x, "y": object.y})

	func deserialise(data):
		return Result.new(Vector2(data.x, data.y))
