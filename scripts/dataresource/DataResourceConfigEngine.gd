######################################################################
# @author      : ElGatoPanzon
# @class       : DataResourceConfigEngine
# @created     : Wednesday Sep 13, 2023 20:39:28 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Holds configuration for the engine
######################################################################

class_name DataResourceConfigEngine
extends DataResource

const ALLOWED_COLORS = ["black", "red", "green", "yellow", "blue", "magenta", "pink", "purple", "cyan", "white", "orange", "gray"]

# object constructor
func _init():
	var prop_ldc = schema_add_property("LoggerDestinationConsole", {
		"type": TYPE_DICTIONARY,
	})

	schema_add_property("color_timestamp", {
		"type": TYPE_STRING,
		"default": "gray",
		"allowed_values": ALLOWED_COLORS,
	}, prop_ldc)
	schema_add_property("color_name", {
		"prototype": "color_timestamp",
		"default": "blue",
	}, prop_ldc)
	schema_add_property("color_level_debug", {
		"prototype": "color_timestamp",
		"default": "green",
	}, prop_ldc)
	schema_add_property("color_level_info", {
		"prototype": "color_timestamp",
		"default": "cyan",
	}, prop_ldc)
	schema_add_property("color_level_warning", {
		"prototype": "color_timestamp",
		"default": "warning",
	}, prop_ldc)
	schema_add_property("color_level_error", {
		"prototype": "color_timestamp",
		"default": "red",
	}, prop_ldc)
	schema_add_property("color_level_critical", {
		"prototype": "color_level_error",
	}, prop_ldc)

	schema_add_property("color_message", {
		"prototype": "color_timestamp",
		"default": "white",
	}, prop_ldc)
	schema_add_property("color_data_name", {
		"prototype": "color_timestamp",
		"default": "cyan",
	}, prop_ldc)
	schema_add_property("color_data_value", {
		"prototype": "color_timestamp",
		"default": "pink",
	}, prop_ldc)
	schema_add_property("color_background", {
		"prototype": "color_timestamp",
		"default": "black",
	}, prop_ldc)
	schema_add_property("color_multiline", {
		"prototype": "color_background",
	}, prop_ldc)

	schema_add_property("padding_timestamp", {
		"type": TYPE_INT,
		"default": 10,
		"min_value": 10,
		"max_value": 100,
	}, prop_ldc)
	schema_add_property("padding_name", {
		"prototype": "padding_timestamp",
	}, prop_ldc)
	schema_add_property("padding_log_level", {
		"prototype": "padding_timestamp",
	}, prop_ldc)
	schema_add_property("padding_message", {
		"prototype": "padding_timestamp",
	}, prop_ldc)
	schema_add_property("padding_data", {
		"prototype": "padding_timestamp",
	}, prop_ldc)

func init(loaded_data):
	if loaded_data:
		_data = loaded_data # validate later

# friendly name when printing object
func _to_string():
	return "DataResourceConfigEngine"

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

