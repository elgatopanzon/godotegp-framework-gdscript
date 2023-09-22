######################################################################
# @author      : ElGatoPanzon
# @class       : test_DataResource
# @created     : Monday Sep 18, 2023 18:08:51 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Tests for the DataResource class
######################################################################

extends GutTest

class TestDataResource:
	extends GutTest

	var data_resource

	# class hooks for setup and teardown
	func before_all():
		pass
	func before_each():
		data_resource = autofree(DataResource.new()) 
	func after_each():
		pass
	func after_all():
		pass

	var p_validation_types = ParameterFactory.named_parameters(["schema", "type", "value", "success"], 
		[
		[{
			
		}, "null", null, true
		],

		[{
			
		}, "bool", true, true
		],
		[{
			
		}, "bool", 1, false
		],
		[{
			
		}, "bool", "string", false
		],

		[{
			
		}, "int", true, false
		],
		[{
			
		}, "int", 1, true
		],
		[{
			
		}, "int", "string", false
		],

		[{
			
		}, "float", 1, false
		],
		[{
			
		}, "float", 1.1, true
		],
		[{
			
		}, "float", "string", false
		],

		[{
			
		}, "string", "string", true
		],
		[{
			
		}, "string", true, false
		],

		[{
			"properties": {"value": {"type": "bool"}}
		}, "dict", {"value": true}, true
		],
		[{
			"properties": {"value": {"type": "int"}}
		}, "dict", "nope", false
		],

		[{
			"items": {"type": "int"}
		}, "array", [1], true
		],
		[{
			"items": {"type": "int"}
		}, "array", ["nope"], false
		],

		[{
			"object": "DataResource"
		}, "object", DataResource.new(), true
		],
		[{
			"object": "DataResource"
		}, "object", false, false
		],

		]
		)

	# asserts for this class
	func test_assert_validation_types(p=use_parameters(p_validation_types)):
		# override schema to avoid the set methods
		data_resource._data_schema = p.schema

		# set the expected type and init any empty value
		data_resource.schema_set_type(p.type)

		var data_resource_r = data_resource.init(p.value)

		assert_eq(data_resource_r.SUCCESS, p.success, "Value %s is type %s: %s" % [p.value, p.type, data_resource_r.SUCCESS])


	# defults from scheme
	var p_defaults_from_schema = ParameterFactory.named_parameters(["schema", "type", "value", "success"], 
		[
		[{
			"default": null
		}, "null", null, null
		],

		[{
			"default": true
		}, "bool", null, true
		],

		[{
			"default": 10
		}, "int", null, 10
		],

		[{
			"default": 1.1
		}, "float", null, 1.1
		],

		[{
			"default": "test"
		}, "string", null, "test"
		],

		[{
			"properties": {"value": {"type": "bool", "default": true}},
			"default": {"value": true}
		}, "dict", null, {"value": true}
		],

		[{
			"items": {"type": "int", "default": 1},
			"default": [1]
		}, "array", null, [1]
		],

		]
		)

	func test_assert_default_values_from_schema(p=use_parameters(p_defaults_from_schema)):
		# override schema to avoid the set methods
		data_resource._data_schema = p.schema

		# set the expected type and init any empty value
		data_resource.schema_set_type(p.type)

		var data_resource_r = data_resource.validate_data()
		
		if not data_resource_r.SUCCESS:
			gut.p(data_resource_r.error.to_dict())
		assert_eq(data_resource._data, p.success, "Value %s matches default of %s: %s" % [data_resource._data_schema['default'], p.success, data_resource_r.SUCCESS])


	# constraints
	var p_validation_constraints = ParameterFactory.named_parameters(["schema", "type", "value", "success"], 
		# min value
		[
		[{
			"min_value": 1,
		}, "int", 0, false
		],
		[{
			"min_value": 1,
		}, "int", 1, true
		],
		[{
			"min_value": 1,
		}, "int", 2, true
		],

		# max value
		[{
			"max_value": 1,
		}, "int", 2, false
		],
		[{
			"max_value": 1,
		}, "int", 1, true
		],
		[{
			"max_value": 1,
		}, "int", 0, true
		],

		# min and max value
		[{
			"min_value": 1,
			"max_value": 2,
		}, "int", 0, false
		],
		[{
			"min_value": 1,
			"max_value": 2,
		}, "int", 1, true
		],
		[{
			"min_value": 1,
			"max_value": 2,
		}, "int", 2, true
		],
		[{
			"min_value": 1,
			"max_value": 2,
		}, "int", 3, false
		],

		[{
			"min_value": 1.0,
			"max_value": 2.0,
		}, "float", 0.0, false
		],
		[{
			"min_value": 1.0,
			"max_value": 2.0,
		}, "float", 1.0, true
		],
		[{
			"min_value": 1.0,
			"max_value": 2.0,
		}, "float", 2.0, true
		],
		[{
			"min_value": 1.0,
			"max_value": 2.0,
		}, "float", 3.0, false
		],

		# min and max length string
		[{
			"min_length": 1,
			"max_length": 5,
		}, "string", "", false
		],
		[{
			"min_length": 1,
			"max_length": 5,
		}, "string", "l", true
		],
		[{
			"min_length": 1,
			"max_length": 5,
		}, "string", "long", true
		],
		[{
			"min_length": 1,
			"max_length": 5,
		}, "string", "longer", false
		],

		# min and max items in array
		[{
			"min_items": 1,
			"max_items": 5,
			"items": {"type": "int"},
		}, "array", [], false
		],
		[{
			"min_items": 1,
			"max_items": 5,
			"items": {"type": "int"},
		}, "array", [1,2,3,4], true
		],
		[{
			"min_items": 1,
			"max_items": 5,
			"items": {"type": "int"},
		}, "array", [1,2,3,4], true
		],
		[{
			"min_items": 1,
			"max_items": 5,
			"items": {"type": "int"},
		}, "array", [1,2,3,4,5,6], false
		],

		# allowed_values
		[{
			"allowed_values": [1,2,3],
		}, "int", 1, true
		],
		[{
			"allowed_values": [1,2,3],
		}, "int", 0, false
		],
		[{
			"items": {"type": "int"},
			"allowed_values": [1,2,3],
		}, "array", [1,2,3], true
		],
		[{
			"items": {"type": "int"},
			"allowed_values": [1,2,3],
		}, "array", [1,2,3,4,5,6], false
		],

		# items with unique values
		[{
			"items": {"type": "int"},
			"unique": true,
		}, "array", [1,2,3,4,5,6], true
		],
		[{
			"items": {"type": "int"},
			"unique": true,
		}, "array", [1,2,2,2,5,6], false
		],

		]
		)


	func test_assert_validation_constraints(p=use_parameters(p_validation_constraints)):
		# override schema to avoid the set methods
		data_resource._data_schema = p.schema

		# set the expected type and init any empty value
		data_resource.schema_set_type(p.type)

		var data_resource_r = data_resource.init(p.value)
		
		assert_eq(data_resource_r.SUCCESS, p.success, "Validation of constraints is %s: %s" % [p.success, data_resource_r.SUCCESS])

	# resource merging
	func test_assert_resource_merging():
		data_resource._data_schema = {
			"type": "dict",
			"properties": {
				"value": {
					"type": "bool",
					"default": true
				},
				"value2": {
					"type": "bool",
					"default": false
				}
			}
		}

		data_resource.init({"value": true, "value2": false})

		# create second instance
		var dr2 = DataResource.new()
		dr2._data_schema = data_resource._data_schema

		dr2.init({"value": false, "value2": true})

		gut.p(data_resource._data)
		gut.p(dr2._data)
		data_resource.merge_resource(dr2)

		assert_eq(data_resource._data['value'], false, "Data was merged")
		assert_eq(data_resource._data['value2'], true, "Data was merged")

	#  get data construct from schema
	func test_assert_data_from_schema():
		data_resource._data_schema = {
			"type": "dict",
			"properties": {
				"value": {
					"type": "bool",
					"default": true
				}
			}
		}

		var data = data_resource.data_from_schema()

		assert_eq(data, {"value": true}, "Data from schema matches")

	# object serialisation and deserialisation
	func test_assert_object_serialisation_during_init():
		data_resource._data_schema = {
			"type": "object",
			"object": "Vector2"
		}

		var data_resource_r = data_resource.init({"x": 1, "y": 2})

		gut.p(data_resource_r.SUCCESS)
		if not data_resource_r.SUCCESS:
			gut.p(data_resource_r.error.get_errors()[0].to_dict())
			gut.p(data_resource._data)

		# assert_eq(data_resource._data.x, 1, "x matches")
		# assert_eq(data_resource._data.y, 2, "y matches")
