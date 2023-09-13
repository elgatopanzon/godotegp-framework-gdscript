######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerCollection
# @created     : Saturday Sep 09, 2023 12:55:42 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Object to hold a collection of Loggers and log to them
######################################################################

class_name LoggerCollection
extends Node

var _name
var _level: String
var _loggers: Array[Logger]

var _levels = ["debug", "info", "warning", "error", "critical"]

var _enabled: bool = true

var _queue: Array[EventLoggerLine]

# queue has some side effects
# 1. crash loses the current queue
# 2. objects are printed late, when their values already changed
var _queue_enabled: bool = false

# object constructor
func _init(level: String = "debug"):
	set_level(level)

func set_name(name):
	_name = name

func set_level(level: String):
	if level in _levels:
		_level = level
	else:
		printerr("Invalid log level %s" % [level])

func enable():
	set_enabled(true)

func disable():
	set_enabled(false)

func set_enabled(state):
	_enabled = state

func is_enabled():
	return _enabled

func queue_enabled():
	return _queue_enabled

func set_queue_enabled(state: bool):
	_queue_enabled = state

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

# add a Logger to collection
func add_logger(logger: Logger):
	if not logger in _loggers:
		_loggers.append(logger)

		return true

# remove a Logger from the collection
func remove_logger(logger: Logger):
	if logger in _loggers:
		_loggers.erase(logger)

		return true

# logging methods to log to all Logger instances
func debug(value, data_name = null, data = null):
	self.log("debug", value, data_name, data)
func info(value, data_name = null, data = null):
	self.log("info", value, data_name, data)
func warning(value, data_name = null, data = null):
	self.log("warning", value, data_name, data)
func error(value, data_name = null, data = null):
	self.log("error", value, data_name, data)
func critical(value, data_name = null, data = null):
	self.log("critical", value, data_name, data)

# log to all Logger instances
func log(log_level: String, value, data_name = null, data = null):
	if can_log_with_level(log_level) and is_enabled():
		if _queue_enabled and Services.get("Log"):
			# hacky: pass the event to the Logger service so we have a single ordered queue
			# the service will later process them in order during game loop
			# result: non-blocking logging
			Services.Log.queue_logging_event(EventLoggerLine.new(_name, log_level, value, data_name, data, self))
		else:
			# no queue, process it right now
			log_to_loggers(null, log_level, value, data_name, data)

func log_to_loggers(time, log_level, value, data_name, data):
	for logger in _loggers:
		var log_result = logger.log(time, _name, log_level, value, data_name, data)

# check if we can log with a given log level
func can_log_with_level(log_level: String):
	return max(0, _levels.find(log_level, 0)) >= _levels.find(_level, 0)

# process an EventLoggerLine event
func process_event(event: EventLoggerLine):
	log_to_loggers(event.get_time(), event.get_level(), event.get_value(), event.get_data_name(), event.get_data_value())
