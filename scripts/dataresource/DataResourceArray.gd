######################################################################
# @author      : ElGatoPanzon
# @class       : DataResourceArray
# @created     : Wednesday Sep 13, 2023 11:55:27 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Holds an Array of a specificed DataResource object
######################################################################

class_name DataResourceArray
extends DataResource

var _data_resource_type

# object constructor
func _init(data_resource_type):
	_data_resource_type = data_resource_type

	# init data as an array
	_data = []

func init(loaded_data):
	if typeof(loaded_data) != TYPE_ARRAY:
		logger().critical("Expected an array of data", "loaded_data", loaded_data)
		return false
	else:
		return create_resource_objects(loaded_data)

	return self

# friendly name when printing object
func _to_string():
	return "DataResourceArray"

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

# create resource objects from the array of data items
func create_resource_objects(loaded_data: Array):
	for data in loaded_data:
		var resource = _data_resource_type.new().init(data)

		# if we get back a valid resource then the loaded data is valid
		if resource:
			_data.append(resource)
		else:
			logger().critical("Resource object creation failed", "resource_type", _data_resource_type.get_script().get_path().replace(".gd", ""))
			logger().critical("...", "data", data)

			return null

	return self
