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
	var file_content = get_file_as_text()

	if not file_content:
		return null

	# override text file content
	if _file_ext == "json":
		var json = JSON.new()
		var parsed_json_result = json.parse(file_content)

		if parsed_json_result == OK:
			file_content = json.data
		else:
			Services.Events.error(self, "parsing_json_failed", {"path": _file_object.get_path(), "error": parsed_json_result, "error_msg": json.get_error_message()})

			return parsed_json_result

	# return file content
	return file_content

func save_to_file(data_resource):
	if _file_ext == "json":
		var stringified_json = JSON.stringify(data_resource._data) # is this safe?

		if stringified_json:
			_file_object.store_line(stringified_json)
		else:
			Services.Events.error(self, "stringify_json_failed", {"path": _file_object.get_path()})

			return null

	# assume it's plain text and store it
	else:
		_file_object.store_string(str(data_resource._data))

	var file_error = _file_object.get_error()

	if file_error:
		Services.Events.error(self, "parsing_json_failed", {"path": _file_object.get_path(), "error": file_error})

		return null

	return true
