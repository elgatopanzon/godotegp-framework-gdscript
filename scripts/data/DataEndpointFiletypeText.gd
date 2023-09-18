######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointFiletypeText
# @created     : Tuesday Sep 12, 2023 21:55:10 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Implementation for loading text files
######################################################################

class_name DataEndpointFiletypeText
extends DataEndpointFiletype

# object constructor
func _init():
	SUPPORTED_EXTENSIONS = ["txt", "json"] 
	pass

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataEndpointFiletypeText"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

func load_from_file():
	var result = get_file_as_text()

	if not result.SUCCESS:
		return result
	
	# get value from result object
	var file_content = result.value

	# parse supported filetypes content
	if _file_ext == "json":
		var parse_r = DataEndpointParserJSON.new().parse(file_content, _file_ext)

		if not parse_r.SUCCESS:
			return parse_r
		else:
			file_content = parse_r.value

	# return file content
	return Result.new(file_content)

func save_to_file(data_resource):
	if _file_ext == "json":
		var unparse_r = DataEndpointParserJSON.new().unparse(data_resource._data, _file_ext)

		if not unparse_r.SUCCESS:
			return unparse_r
		else:
			_file_object.store_line(unparse_r.value)

	# assume it's plain text and store it
	else:
		_file_object.store_string(str(data_resource._data))

	var file_error = _file_object.get_error()

	if file_error:
		var error = Services.Events.error(self, file_error, {"path": _file_object.get_path(), "error": file_error})

		return Result.new(false, error)

	# return true result object
	return Result.new(true)
