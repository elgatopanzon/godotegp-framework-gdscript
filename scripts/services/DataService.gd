######################################################################
# @author      : ElGatoPanzon
# @class       : DataService
# @created     : Tuesday Sep 12, 2023 19:38:03 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service to handle saving and loading of data 
# 				 via Data objects and DataResource destination objects
######################################################################

class_name DataService
extends Service

var FS: DataServiceFS

func _init(name: String):
	set_name(name)

	FS = Services.DataFS

	set_ready()

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataService"

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

func load(data_object: Data):
	return data_object.load_data()

func save(data_object: Data):
	return data_object.save_data()
