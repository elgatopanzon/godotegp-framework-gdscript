######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointParser
# @created     : Wednesday Sep 13, 2023 15:19:25 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base class to implement data parser
######################################################################

class_name DataEndpointParser
extends Resource

var SUPPORTED_CONTENT_TYPES = [] 

var _content_type: String

# object constructor
func _init():
	pass

func init():
	return self

func get_content_type():
	return _content_type
func set_content_type(type: String):
	_content_type = type

# friendly name when printing object
func _to_string():
	return "DataEndpointParser"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

func is_supported_content_type(content_type: String):
	return content_type in SUPPORTED_CONTENT_TYPES
