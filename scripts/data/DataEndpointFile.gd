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
		var error = Services.Events.error(self, "unsupported_extension", {"ext": _file_ext, "path": _file_path, "resource": _data_resource})

		return Result.new(false, error)	

	# check if file exists when loading
	if type == 0 and not FileAccess.file_exists(_file_path):
		var error = Services.Events.error(self, "file_not_found", {"ext": _file_ext, "path": _file_path, "resource": _data_resource})

		return Result.new(false, error)	

	var file = null
	if type == 0:
		file = get_file_object(FileAccess.READ) # open for reading only
	else:
		file = get_file_object(FileAccess.WRITE_READ) # write file if it doesn't exist

	# check the result object for success
	if not file.SUCCESS:
		var error = Services.Events.error(self, file.error.get_type(), file.error.get_type())

		return Result.new(false, error)	
	else:
		# set the file object to the value when there's no errors
		file = file.value

	# set needed data by extension implementation
	extension_implementation.set_file_object(file)
	extension_implementation.set_file_ext(_file_ext)

	# returns upstream result object directly which includes upstream errors
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
		return Result.new(file)
	else:
		return Result.new(false, ResultError.new(self, FileAccess.get_open_error(), {"ext": _file_ext, "path": _file_path, "resource": _data_resource}))
