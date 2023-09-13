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