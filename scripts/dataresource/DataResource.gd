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

const TYPE_STRING_MAPPINGS: Dictionary = {
	"null": TYPE_NIL,
	"bool": TYPE_BOOL,
	"int": TYPE_INT,
	"float": TYPE_FLOAT,
	"string": TYPE_STRING,
	"vector2": TYPE_VECTOR2,
	"vector2i": TYPE_VECTOR2I,
	"rect2": TYPE_RECT2,
	"rect2i": TYPE_RECT2I,
	"vector3": TYPE_VECTOR3,
	"vector3i": TYPE_VECTOR3I,
	"transform2d": TYPE_TRANSFORM2D,
	"vector4": TYPE_VECTOR4,
	"vector4i": TYPE_VECTOR4I,
	"plane": TYPE_PLANE,
	"quaternion": TYPE_QUATERNION,
	"aabb": TYPE_AABB,
	"basis": TYPE_BASIS,
	"transform3d": TYPE_TRANSFORM3D,
	"projection": TYPE_PROJECTION,
	"color": TYPE_COLOR,
	"string_name": TYPE_STRING_NAME,
	"node_path": TYPE_NODE_PATH,
	"rid": TYPE_RID,
	"object": TYPE_OBJECT,
	"callable": TYPE_CALLABLE,
	"signal": TYPE_SIGNAL,
	"dict": TYPE_DICTIONARY,
	"array": TYPE_ARRAY,
	"packed_byte_array": TYPE_PACKED_BYTE_ARRAY,
	"packed_int32_array": TYPE_PACKED_INT32_ARRAY,
	"packed_int64_array": TYPE_PACKED_INT64_ARRAY,
	"packed_float32_array": TYPE_PACKED_FLOAT32_ARRAY,
	"packed_float64_array": TYPE_PACKED_FLOAT64_ARRAY,
	"packed_string_array": TYPE_PACKED_STRING_ARRAY,
	"packed_vector2_array": TYPE_PACKED_VECTOR2_ARRAY,
	"packed_vector3_array": TYPE_PACKED_VECTOR3_ARRAY,
	"packed_color_array": TYPE_PACKED_COLOR_ARRAY,
	"max": TYPE_MAX,
}

var _data

var _data_schema: Dictionary

func _init():
	pass

# take the loaded data and validate it, called usually by the Data object during loading
func init(loaded_data = null):
	if loaded_data == null:
		loaded_data = _data

	# directly set data when there's no schema
	if loaded_data != null:
		_data = loaded_data

		if has_schema():
			# set and validate the data
			var result = validate_data()

			if not result.SUCCESS:
				var error = Services.Events.error(self, "validation_failed")

				error.add_error(result.error)

				_data = null # clear it all, it's not valid

				return Result.new(false, error)

	return Result.new(self)

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

func merge_resource(resource: DataResource):
	# basic implementation is to overwrite the data
	if not has_schema():
		_data = resource._data

		emit_event_data_changed()

		return Result.new(true)
	else:
		var r =  process_resource_merge(resource, _data_schema, _data, resource._data)

		if r.SUCCESS:
			emit_event_data_changed()

		return r

# data schema methods
# all schema methods accept a dict object to work on, so we can use the same methods for any nested level
# set the title of this resource
func schema_set_title(title: String, schema_object: Dictionary = _data_schema):
	schema_object['title'] = title

func schema_set_description(description: String, schema_object: Dictionary = _data_schema):
	schema_object['description'] = description

func schema_set_type(type: String, schema_object: Dictionary = _data_schema):
	schema_object['type'] = type

	_data = schema_init_empty_value(schema_object)

func schema_set_default(default, schema_object: Dictionary = _data_schema):
	schema_object['default'] = default

func schema_set_items(items: Dictionary, schema_object: Dictionary = _data_schema):
	schema_object['items'] = items

func schema_set_object_type(object_type: String, schema_object: Dictionary = _data_schema):
	schema_object['object'] = object_type

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

func has_schema():
	return (_data_schema)

# validate the current data against the schema
func validate_data():
	logger().debug("Beginning data validation", "data", _data)

	var r = validate_schema_level()

	if r.SUCCESS:
		emit_event_data_changed()

	return r

# validate the given schema level recursively
func validate_schema_level(schema_level: Dictionary = _data_schema, data = _data):
	var valid = false

	if data == null:
		data = schema_init_empty_value(schema_level)

	logger().debug("Schema validation: starting", "data", {"schema": schema_level, "data": data})

	# if there's a custom callable, use it to validate
	if schema_level.get("callable", null):
		valid = schema_level['callable'].call(schema_level, data)

		# callable must return Result object
		return valid

	# if type was an object, load the data into the class's created instance
	if schema_level['type'] == "object":
		if typeof(data) != TYPE_OBJECT:
			return Result.new(false, ResultError.new(self, "instance_not_valid"))

			# TODO: fix this and create suitable tests
			var instance = schema_init_empty_value(schema_level)

			if instance == null:
				var error = Services.Events.error(self, "schema_object_invalid_class", {"schema": schema_level, "data": data})

				error.add_error(instance.error)

				return Result.new(false, error)
			else:
				var valid_instance = instance.instantiate().init(data)

				if valid_instance.SUCCESS:
					data = valid_instance.value
					
					valid = true
				else:
					var error = Services.Events.error(self, "schema_object_validation_failed", {"schema": schema_level, "data": data})
					error.add_error(valid_instance.error)
					valid = false
					return Result.new(false, error)

	# validate the type
	valid = schema_validate_type(schema_level, data)

	if not valid.SUCCESS:
		return valid

	# validate properties for type dict
	if schema_level['type'] == "dict":
		valid = schema_validate_properties(schema_level, data)

	# validate items for type array
	elif schema_level['type'] == "array":
		valid = schema_validate_items(schema_level, data)

	if not valid.SUCCESS:
		return valid

	# validate the value itself
	logger().debug("Schema value constraints: starting", "data", {"schema": schema_level, "data": data})
	valid = schema_validate_constraints(schema_level, data)

	if not valid.SUCCESS:
		return valid

	return Result.new(true)

func schema_validate_type(schema_level: Dictionary = _data_schema, data = _data):
	var valid = false

	logger().debug("Schema type: validating", "data", {"type": schema_level['type'], "data": data})

	# validate using typeof
	if schema_level['type'] in TYPE_STRING_MAPPINGS:
		# cast to the expected number type if it's a valid number
		if typeof(data) == TYPE_FLOAT and schema_level['type'] == "int":
				data = int(data)

		valid = typeof(data) == TYPE_STRING_MAPPINGS[schema_level['type']]

		# check if the object instance is correct
		if schema_level['type'] == "object":
			var expected_instance = Services.ObjectPool.get_object_pool(schema_level['object']).instantiate()

			if data.get_script() != expected_instance.get_script():
				Services.Events.error(self, "schema_object_mismatch", {"object": schema_level['object'], "actual_object": data})
				valid = false

			Services.ObjectPool.get_object_pool(schema_level['object']).return_instance(expected_instance)
			
		if not valid:
			var error = Services.Events.error(self, "schema_type_mismatch", {"type": schema_level['type'], "actual_type": schema_get_type_string(typeof(data)), "data": data})

			return Result.new(false, error)

	else:
		var error = Services.Events.error(self, "schema_uncaught_type", {"type": schema_level['type'], "actual_type": schema_get_type_string(typeof(data)), "data": data})

		return Result.new(false, error)


	logger().debug("Schema type: result", "result", valid)

	return Result.new(valid)

func schema_validate_properties(schema_level: Dictionary, data = _data):
	var valid = false

	# remove invalid properties
	for property in data:
		if not property in schema_level['properties']:
			logger().warning("Schema property: ignoring unknown property", "property", property)
			data.erase(property)

	var invalid_properties = []
	if schema_level.get("properties", null):
		for property in schema_level['properties']:

			logger().debug("Schema property: validating", "property", property)

			var property_exists = (data.get(property, null) != null)

			# handle when the property doesn't exist in the data we loaded
			if not property_exists:
				# check if property is required
				var required = schema_level['properties'][property].get("required", null)

				# init the default value if there is one
				var default_value = schema_level['properties'][property].get("default", null)

				if required:
					var error = Services.Events.error(self, "schema_required_property_missing", {"property": property})

					invalid_properties.append(error)

				elif default_value:
					data[property] = default_value

					logger().debug("Schema property: setting default", "property", {"property": property, "default": default_value})

				else:
					var empty_default = schema_init_empty_value(schema_level['properties'][property])

					if empty_default != null:
						data[property] = empty_default

			# check property is valid
			if property not in invalid_properties:
				var property_valid = validate_schema_level(schema_level['properties'][property], data.get(property, null))

				if not property_valid.SUCCESS:
					invalid_properties.append(property_valid.error)

	if invalid_properties.size():		
		var error = Services.Events.error(self, "schema_properties_invalid", {"properties": invalid_properties})

		return Result.new(false, error)

	else:
		valid = true

	logger().debug("Schema property: result", "result", valid)

	return Result.new(valid)

func schema_init_empty_value(schema_level: Dictionary):
	var default_value = schema_level.get("default", null)

	if schema_level['type'] == "array":
		if default_value:
			return default_value
		else:
			return []
	elif schema_level['type'] == "dict":
		if default_value:
			return default_value
		else:
			return {}

	# return a fresh instance of the object
	elif schema_level['type'] == "object":
		return Services.ObjectPool.get_object_pool(schema_level['object'])

	# init the value from the defult if there is one
	else:
		if default_value != null:
			return default_value

func schema_validate_items(schema_level: Dictionary, data = _data):
	var valid = false

	var invalid_items = []
	for item in data:
		logger().debug("Schema item: validating", "item", item)

		var item_valid = validate_schema_level(schema_level['items'], item)

		if not item_valid.SUCCESS:
			invalid_items.append(item_valid.error)

	if invalid_items.size():		
		var error = Services.Events.error(self, "schema_items_invalid", {"items": invalid_items})

		return Result.new(true, error)

	else:
		valid = true

	logger().debug("Schema item: result", "result", valid)

	return Result.new(valid)

func schema_validate_constraints(schema_level: Dictionary, data = _data):
	var valid = true

	for constraint in ['min_value', 'max_value', 'min_length', 'max_length', 'min_items', 'max_items', 'allowed_values', 'unique']:
		if constraint in schema_level:
			logger().debug("Schema value constraints: validating", "validation", {"constraint": {"type": constraint, "value": schema_level[constraint]}, "data": data})

			if constraint == "min_value":
				valid = (data >= schema_level[constraint])
			elif constraint == "max_value":
				valid = (data <= schema_level[constraint])

			if constraint == "min_length":
				valid = (len(data) >= schema_level[constraint])
			elif constraint == "max_length":
				valid = (len(data) <= schema_level[constraint])

			if constraint == "min_items":
				valid = (data.size() >= schema_level[constraint])
			elif constraint == "max_items":
				valid = (data.size() <= schema_level[constraint])

			elif constraint == "allowed_values":
				# check if any array item is not in allowed values
				if schema_level['type'] == "array":
					valid = true

					for item in data:
						if item not in schema_level[constraint]:
							valid = false
							break
				else:
					valid = (data in schema_level[constraint])

			elif constraint == "unique":
				var seen = []
				for item in data:
					if not item in seen:
						seen.append(item)

					# found a duplicate
					else:
						valid = false
						break
				
			# if one constraint doesn't match, break
			if not valid:
				var error = Services.Events.error(self, "schema_value_constraint_failed", {"constraint": {"type": constraint, "value": schema_level[constraint]}, "data": data})

				return Result.new(false, error)

	return Result.new(valid)

func schema_get_type_string(type_value):
	for type in TYPE_STRING_MAPPINGS:
		if TYPE_STRING_MAPPINGS[type] == type_value:
			return type

	return false

# move through the scheme recursively and merge them
func process_resource_merge(resource: DataResource, schema_level: Dictionary = _data_schema, data = _data, data_resource = null):
	# overwrite values
	logger().debug("Resource merge: starting")

	if schema_level['type'] == "dict":
		if schema_level.get("properties", null):
			for property in schema_level['properties']:
				if schema_level['properties'][property]['type'] == "dict":
					var result = process_resource_merge(resource, schema_level['properties'][property], data.get(property), data_resource.get(property))

					if not result.SUCCESS:
						return result
				else:
					# override value if the data_resource value is different to the default
					var default = schema_level['properties'][property].get("default", null)
					if data_resource[property] != default and default != null:
						data[property] = data_resource[property]

		return Result.new(true)

	# overwrite values
	else:
		data = data_resource

	return Result.new(data)

# allow getting values of a dict or array
func _get(prop):
	if _data_schema['type'] == "dict":
		return _data.get(prop, null)
	elif _data_schema['type'] == "array":
		return _data[prop]
	
func _set(prop, value):
	emit_event_data_changed()

	if _data_schema['type'] == "dict":
		_data[prop] = value

		return true
	elif _data_schema['type'] == "array":
		_data[prop] = value

		return true
	else:
		return false

func get(prop, default = null):
	var val = _get(prop)

	if val == null:
		val = default

	return val
	

# get data object from schema defaults
func data_from_schema(schema_level: Dictionary = _data_schema, data = {}):
	if schema_level['type'] == "dict":
		if schema_level.get("properties", null):
			for property in schema_level['properties']:
				if schema_level['properties'][property]['type'] == "dict":
					data[property] = data_from_schema(schema_level['properties'][property], data.get(property))
				else:
					# override value if the data_resource value is different to the default
					if not data:
						data = {}
					data[property] = schema_level['properties'][property].get("default", null)

	# overwrite values
	else:
		data = schema_level.get("default", null)

	return data

func emit_event_data_changed():
	Services.Events.emit_now(EventDataResourceChanged.new(self))
