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

var _data_endpoint: DataEndpoint
var _data_resource: DataResource

# object constructor
func _init(data_endpoint: DataEndpoint, data_resource: DataResource):
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

# load function executes the loading operation
func load_data():
	logger().debug("Loading data from endpoint", "dataload", {"endpoint": get_data_endpoint(), "resource": get_data_resource()})

	var loaded_data = get_data_endpoint().load_data()

	if loaded_data:
		return get_data_resource().init(loaded_data)
	else:
		logger().debug("Data loading failed", "dataload", {"endpoint": get_data_endpoint(), "resource": get_data_resource(), "error": loaded_data})

		return null # failed somewhere loading the data, handle it better

# save function executes the saving operation
func save_data():
	logger().debug("Saving data to endpoint", "datasave", {"endpoint": get_data_endpoint(), "resource": get_data_resource()})

	# save the resource to the endpoint
	get_data_endpoint().set_data_resource(get_data_resource())

	var save_result = get_data_endpoint().save_loaded_resource()

	if not save_result:
		logger().debug("Data saving failed", "dataload", {"endpoint": get_data_endpoint(), "resource": get_data_resource(), "error": save_result})

	return save_result
