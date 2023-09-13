######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpoint
# @created     : Tuesday Sep 12, 2023 20:49:21 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base class for DataEndpoint objects
######################################################################

class_name DataEndpoint
extends Resource

var _data_resource: DataResource

func init():
	return self

func get_data_resource():
	return _data_resource
func set_data_resource(data_resource: Resource):
	_data_resource = data_resource

# friendly name when printing object
func _to_string():
	return "DataEndpoint"

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

func load_data():
	return true

func save_data():
	return true

func save_loaded_resource():
	return save_data()
