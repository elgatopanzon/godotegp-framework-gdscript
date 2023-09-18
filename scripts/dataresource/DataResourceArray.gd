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

func init(loaded_data = null):
	if typeof(loaded_data) != TYPE_ARRAY:
		var error = Services.Events.error(self, "data_resource_array_expected", {"loaded_data": loaded_data})

		return Result.new(false, error)
	else:
		# get Result object for the resource creation process from array of items
		return create_resource_objects(loaded_data)

	return Result.new(self)

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
		var result = _data_resource_type.new().init(data)

		# if we get back a valid resource then the loaded data is valid
		if result.SUCCESS:
			_data.append(result.value)
		else:
			var error = Services.Events.error(self, "data_resource_validation_failed", {"resource_type": _data_resource_type.get_script().get_path().replace(".gd", ""), "data": data})

			return result

	# return Result object
	return Result.new(self)
