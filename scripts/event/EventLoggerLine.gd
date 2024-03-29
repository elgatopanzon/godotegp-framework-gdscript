######################################################################
# @author      : ElGatoPanzon
# @class       : EventLoggerLine
# @created     : Monday Sep 11, 2023 16:45:17 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Event holding Logger line data
######################################################################

class_name EventLoggerLine
extends Event

var _time
var _name
var _level: String
var _value: String
var _data_name
var _data_value
var _logger_collection: LoggerCollection

# object constructor
func _init(name, level: String, value: String, data_name, data_value, logger_collection: LoggerCollection):
	_time = Time.get_datetime_dict_from_system() # create the data the moment we create the event

	_name = name
	_level = level
	_value = value
	_data_name = data_name
	_data_value = data_value
	_logger_collection = logger_collection

func get_time():
	return _time
func get_name():
	return _name
func get_level():
	return _level
func get_value():
	return _value
func get_data_name():
	return _data_name
func get_data_value():
	return _data_value
func get_logger_collection():
	return _logger_collection

func init():
	return self

# friendly name when printing object
func _to_string():
	return "EventLoggerLine"

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

