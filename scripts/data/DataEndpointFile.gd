######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointFile
# @created     : Tuesday Sep 12, 2023 21:48:48 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : 
######################################################################

class_name DataEndpointFile
extends DataEndpoint

var FILETYPE_IMPLEMENTS = [
	DataEndpointFiletypeText.new(),
	DataEndpointFiletypeCSV.new(),
	DataEndpointFiletypeINI.new(),
]


var _file_path: String
var _file_ext: String

# object constructor
func _init(file_path: String, file_ext: String = ""):
	_file_path = file_path

	if file_ext:
		_file_ext = file_ext
	else:
		_file_ext = _file_path.get_extension()

	logger().debug("file path", "path", _file_path)
	logger().debug("file extension", "ext", _file_ext)

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataEndpointFile"

func to_dict():
	return {
		"file_path": _file_path,
		"file_ext": _file_ext
	}

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

# file operation methods
func get_extension_implementation():
	for imp in FILETYPE_IMPLEMENTS:
		if imp.is_supported_extension(_file_ext):
			return imp

	return false

func load_data():
	return process_file_operation(0)

func save_data():
	return process_file_operation(1)

func process_file_operation(type: int):
	var extension_implementation = get_extension_implementation()

	# file extension not implemented
	if not extension_implementation:
		logger().critical("Unsupported extension", "ext", _file_ext)
		logger().critical("...", "path", _file_path)
		logger().critical("...", "resource", _data_resource)

		return null	

	# check if file exists when loading
	if type == 0 and not FileAccess.file_exists(_file_path):
		logger().critical("File not found", "path", _file_path)

		return null

	var file = null
	if type == 0:
		file = get_file_object(FileAccess.READ) # open for reading only
	else:
		file = get_file_object(FileAccess.WRITE_READ) # write file if it doesn't exist

	# if file is null we cant access the file
	if not file:
		logger().critical("Unable to get file handle", "path", _file_path)

		return file

	# set needed data by extension implementation
	extension_implementation.set_file_object(file)
	extension_implementation.set_file_ext(_file_ext)

	if type == 0:
		var load_result = extension_implementation.load_from_file()

		file.close()

		return load_result
	else:
		var save_result =  extension_implementation.save_to_file(_data_resource)

		file.close()

		return save_result


func get_file_object(access_type: int = FileAccess.READ_WRITE):
	var file = FileAccess.open(_file_path, access_type)

	if file:
		return file
	else:

		return null
