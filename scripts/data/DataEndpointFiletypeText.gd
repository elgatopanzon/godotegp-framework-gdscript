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

# object destructor
# func _notification(what):
#     if (what == NOTIFICATION_PREDELETE):
#         pass


# scene lifecycle methods
# called when node enters the tree
# func _enter_tree():
# 	pass

# called once when node is ready
# func _ready():
#	pass

# called when node exits the tree
# func _exit_tree():
#	pass


# process methods
# called during main loop processing
# func _process(delta: float):
#	pass

# called during physics processing
# func _physics_process(delta: float):
#	pass

func process_load_from_file(file_path, file_ext):
	var file = get_file_object(file_path)

	if file:
		var file_content = file.get_as_text(true)

		var file_error = file.get_error()
		file.close()

		if file_ext == "json":
			var json = JSON.new()
			var parsed_json_result = json.parse(file_content)

			if parsed_json_result == OK:
				file_content = json.data
			else:
				return parsed_json_result


		if not file_content:
			return file_error
		else:
			return file_content
	else:
		return null

func process_save_to_file(file_path, file_ext, data_resource):
	var file = get_file_object(file_path, FileAccess.WRITE_READ)

	if file:
		if file_ext == "json":
			var stringified_json = JSON.stringify(data_resource._data)
			if stringified_json:
				file.store_line(stringified_json)
			else:
				return false
		else:
			file.store_string(str(data_resource._data))

		var file_error = file.get_error()
		file.close()

		if file_error:
			return file_error
		else:
			return true
	else:
		return null
