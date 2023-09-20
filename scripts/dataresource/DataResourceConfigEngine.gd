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
const ALLOWED_LOG_LEVELS = ["debug", "none", "info", "warning", "error", "critical"]

# object constructor
func _init():
	schema_set_type("dict") # expected data is a dict

	# config for logger_console LoggerDestinationConfig
	var prop_logger = schema_add_property("logger", {
		"type": "dict",
	})

	schema_add_property("log_level_debug", {
		"type": "string",
		"default": "debug",
		"allowed_values": ALLOWED_LOG_LEVELS,
	}, prop_logger)
	schema_add_property("log_level_release", {
		"prototype": "log_level_debug",
		"default": "info",
	}, prop_logger)

	# config for logger_console LoggerDestinationConfig
	var prop_ldc = schema_add_property("logger_console", {
		"type": "dict",
	})

	schema_add_property("color_timestamp", {
		"type": "string",
		"default": "gray",
		"allowed_values": ALLOWED_COLORS,
	}, prop_ldc)
	schema_add_property("color_name", {
		"prototype": "color_timestamp",
		"default": "gray",
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
		"default": "orange",
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
		"type": "int",
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

# friendly name when printing object
func _to_string():
	return "DataResourceConfigEngine"

# integration with Services.Log
func logger():
	Services.Log.get(self.to_string()).set_level("warning")
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass
