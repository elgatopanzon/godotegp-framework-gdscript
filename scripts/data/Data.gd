######################################################################
# @author      : ElGatoPanzon
# @class       : Data
# @created     : Tuesday Sep 12, 2023 19:44:43 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base Data class
######################################################################

class_name Data
extends Resource

var _data_endpoint
var _data_resource: Resource

# object constructor
func _init(data_endpoint, data_resource: Resource):
	set_data_resource(data_resource)
	set_data_endpoint(data_endpoint)

func init():
	return self

func get_data_endpoint():
	return _data_endpoint
func set_data_endpoint(data_endpoint):
	_data_endpoint = data_endpoint

func get_data_resource():
	return _data_resource
func set_data_resource(data_resource: Resource):
	_data_resource = data_resource

# friendly name when printing object
func _to_string():
	return "Data"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

# load_check function checks loading is possible
func load_check():
	return true

# save check function checks saving is possible
func save_check():
	return true

# load function executes the loading operation
func load_data():
	logger().debug("Dummy loading data from endpoint", "endpoint", get_data_endpoint())
	return get_data_resource()

# save function executes the saving operation
func save_data():
	logger().debug("Dummy saving data to console", "data", get_data_resource().to_dict())
	return true
