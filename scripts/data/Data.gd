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

	logger().debug("Creating Data operation request", "data", {"endpoint": get_data_endpoint().to_dict(), "resource": get_data_resource()})

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
	logger().debug("Loading data from endpoint", "data", {"endpoint": get_data_endpoint().to_dict(), "resource": get_data_resource()})

	var loaded_data = get_data_endpoint().load_data()

	# for the most part, we can pass up the errors
	if loaded_data.SUCCESS:
		return get_data_resource().init(loaded_data.value)
	else:
		var error = Services.Events.error(self, "data_loading_failed", {"endpoint": get_data_endpoint().to_dict(), "resource": get_data_resource(), "error": loaded_data.error.to_dict()})

		# add upstream errors to our local error
		error.add_error(loaded_data.error)

		return Result.new(false, error)

# save function executes the saving operation
func save_data():
	logger().debug("Saving data to endpoint", "data", {"endpoint": get_data_endpoint().to_dict(), "resource": get_data_resource()})

	# save the resource to the endpoint
	get_data_endpoint().set_data_resource(get_data_resource())

	var save_result = get_data_endpoint().save_loaded_resource()

	# for the most part, we can pass up the errors
	if not save_result.SUCCESS:
		var error = Services.Events.error(self, "data_writing_failed", {"endpoint": get_data_endpoint().to_dict(), "resource": get_data_resource(), "error": save_result.error.to_dict()})

		# add upstream errors to our local error
		error.add_error(save_result.error)

		return Result.new(false, error)

	# return the Result object
	return save_result
