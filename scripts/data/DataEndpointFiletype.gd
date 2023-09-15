######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointFiletype
# @created     : Tuesday Sep 12, 2023 21:53:17 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base class implementing a filetype loader
######################################################################

class_name DataEndpointFiletype
extends Resource

var SUPPORTED_EXTENSIONS = [] 

var _file_object: FileAccess
var _file_ext: String # override how we treat the file

# object constructor
func _init():
	pass

func init():
	return self

func set_file_object(file: FileAccess):
	_file_object = file
func get_file_object():
	return _file_object

func get_file_ext():
	return _file_ext
func set_file_ext(ext: String):
	_file_ext = ext

# friendly name when printing object
func _to_string():
	return "DataEndpointFiletype"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

func is_supported_extension(ext: String):
	return ext in SUPPORTED_EXTENSIONS

# get file content as text
func get_file_as_text(skip_cr: bool = true):
	var file_content = _file_object.get_as_text(skip_cr)
	var file_error = _file_object.get_error()

	if file_error:
		logger().critical("Get file as text failed", "data", {"path": _file_object.get_path(), "error_no": file_error})

		return null

	return file_content
