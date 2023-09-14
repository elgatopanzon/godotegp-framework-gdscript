######################################################################
# @author      : ElGatoPanzon
# @class       : DataResource
# @created     : Tuesday Sep 12, 2023 20:04:57 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base class allows stores data and validating schema
######################################################################

class_name DataResource
extends Resource

var _data

var _data_schema: Dictionary

func _init():
	pass

# take the loaded data and validate it, called usually by the Data object during loading
func init(loaded_data):
	if loaded_data:
		_data = loaded_data # no validation for now

	return self

# friendly name when printing object
func _to_string():
	return "DataResource"

func to_dict():
	return _data

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

# directly set the data of the resource (only for testing!)
func from_dict(dict: Dictionary):
	_data = dict
	return true

func merge(resource: DataResource):
	# basic implementation is to overwrite the data
	_data = resource._data

	return true

# data schema methods
# all schema methods accept a dict object to work on, so we can use the same methods for any nested level
# set the title of this resource
func schema_set_title(title: String, schema_object: Dictionary = _data_schema):
	schema_object['title'] = title

func schema_set_description(description: String, schema_object: Dictionary = _data_schema):
	schema_object['description'] = description

func schema_set_type(type: String, schema_object: Dictionary = _data_schema):
	schema_object['type'] = type

func schema_set_default(default, schema_object: Dictionary = _data_schema):
	schema_object['default'] = default

func schema_set_items(items: Dictionary, schema_object: Dictionary = _data_schema):
	schema_object['items'] = items

func schema_set_properties(properties: Dictionary, schema_object: Dictionary = _data_schema):
	schema_object['properties'] = properties

func schema_set_allowed_values(allowed_values: Array, schema_object: Dictionary = _data_schema):
	schema_object['allowed_values'] = allowed_values

func schema_add_property(id: String, property_data: Dictionary, schema_object: Dictionary = _data_schema):
	if not schema_object.get("properties", null):
		schema_set_properties({}, schema_object)

	if "prototype" in property_data:
		var prototype_base = schema_object['properties'].get(property_data['prototype'], null)

		if prototype_base:
			var property_data_clone = property_data.duplicate()

			property_data = prototype_base.duplicate()

			# merge new data
			for key in property_data_clone:
				property_data[key] = property_data_clone[key]

	schema_object['properties'][id] = property_data
	return schema_object['properties'][id]

# set key and value on schema object
func schema_set(schema_key: String, value, schema_object: Dictionary = _data_schema):
	schema_object[schema_key] = value
