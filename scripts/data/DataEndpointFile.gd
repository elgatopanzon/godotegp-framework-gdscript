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

	logger().critical("Unsupported extension", "ext", _file_ext)
	logger().critical("...", "path", _file_path)
	logger().critical("...", "resource", _data_resource)

	return false

func load_data():
	var imp = get_extension_implementation()

	if not FileAccess.file_exists(_file_path):
		logger().critical("File not found", "path", _file_path)
		return null

	if not imp:
		return null
	else:
		return imp.load_from_file(_file_path, _file_ext)

func save_data():
	var imp = get_extension_implementation()

	if not imp:
		return null
	else:
		return imp.save_to_file(_file_path, _file_ext, _data_resource)
