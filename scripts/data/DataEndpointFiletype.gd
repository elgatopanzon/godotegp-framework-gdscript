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

# object constructor
func _init():
	pass

func init():
	return self

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

func load_from_file(file_path: String, file_ext: String):
	return process_load_from_file(file_path, file_ext)

func save_to_file(file_path: String, file_ext: String, data_resource: DataResource):
	return process_save_to_file(file_path, file_ext, data_resource)

func get_file_object(file_path: String, access_type: int = FileAccess.READ_WRITE):
	return FileAccess.open(file_path, access_type)

func process_load_from_file(file_path, file_ext):
	return true

func process_save_to_file(file_path, file_ext, data_resource):
	return true
