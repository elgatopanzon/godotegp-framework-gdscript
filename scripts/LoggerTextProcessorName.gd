######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextProcessorName
# @created     : Saturday Sep 09, 2023 21:07:12 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Format the name value based on data type
######################################################################

class_name LoggerTextProcessorName
extends LoggerTextProcessor

# object constructor
func _init():
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

func process(value, value_original):
	if typeof(value_original) == TYPE_STRING:
		return value
	elif value_original.has_method("get_logger_name"):
		return value_original.get_logger_name()
	elif value_original.has_method("get_script"):
		if value_original.get_script():
			return class_info_to_string(get_class_info_from_path(value_original.get_script().get_path()), value_original)
		else:
			return value
	else:
		return value

func get_class_info_from_path(path):
	for global_class in ProjectSettings.get_global_class_list():
		if global_class['path'] == path:
			return global_class

func class_info_to_string(class_info, value_original):
	return "%s => %s (%s)" % [class_info.base, class_info.class, value_original]
