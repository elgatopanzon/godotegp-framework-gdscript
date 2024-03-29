######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointFiletypeINI
# @created     : Wednesday Sep 13, 2023 00:26:22 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : 
######################################################################

class_name DataEndpointFiletypeINI
extends DataEndpointFiletype

var _config_object: ConfigFile

# object constructor
func _init():
	SUPPORTED_EXTENSIONS = ["ini", "cfg"] 

	_config_object = ConfigFile.new()

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataEndpointFiletypeINI"

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

	var load_error = _config_object.parse(file_content)

	if load_error != OK:
		var error = Services.Events.error(self, load_error, {"file": _file_object.get_path(), "error": load_error})

		return Result.new(false, error)

	# parse sections into dict
	var parsed_dict = {}

	for section in _config_object.get_sections():
		var keys = _config_object.get_section_keys(section)

		if not parsed_dict.get(section):
			parsed_dict[section] = {}
		else:
			var error = Services.Events.error(self, "duplicate_section_found", {"file": _file_object.get_path(), "section": section})

			return Result.new(false, error)

		for key in keys:
			var value = _config_object.get_value(section, key, null)

			parsed_dict[section][key] = value

			
	return Result.new(parsed_dict)

# only supports dict resources with 1 level deep
func save_to_file(data_resource: DataResource):
	var data = data_resource.to_dict()

	if typeof(data) != TYPE_DICTIONARY:
		return Result.new(false, ResultError.new(self, "data_resource_invalid_dict", {"data": data}))

	# loop over sections
	for section_name in data:
		var section_name_value = data[section_name]
		
		for key_name in section_name_value:
			var key_value = section_name_value[key_name]

			# populate the config object with dict data
			_config_object.set_value(section_name, key_name, key_value)

	var save_error = _config_object.save(_file_object.get_path())

	if save_error != OK:
		var error = Services.Events.error(self, save_error, {"file": _file_object.get_path(), "error": save_error})

		return Result.new(false, error)

	return Result.new(true)
