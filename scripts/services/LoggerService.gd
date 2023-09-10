######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerService
# @created     : Friday Sep 08, 2023 22:20:40 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service to log to a collection of Loggers
######################################################################

class_name LoggerService
extends ServiceManagerService

# hold the LoggerCollection instances
var _logger_collections: Dictionary

var _default_log_level: String

# object constructor
func _init(default_log_level: String = "debug"):
	set_default_log_level(default_log_level)

	# create self LoggerCollection to allow us to log from here as early as possible
	var lc = LoggerCollection.new()
	lc.set_name(get_logger_name())
	lc.set_level(_default_log_level) # set the log level to the default

	_logger_collections[get_logger_name()] = lc 

	# setup default loggers
	var logger_console = Logger.new()
	var logger_destination_console = LoggerDestinationConsole.new()
	logger_console.add_destination(logger_destination_console)

	# add all the default LoggerTextBlocks for this type of destination
	logger_destination_console.setup_default_text_blocks()

	# add logger as reusable collection
	self.register_logger(logger_console, "default")

	self.register_logger("default", get_logger_name())

func logger():
	return self.get(get_logger_name())

func get_logger_name():
	return "LoggerService"

func set_default_log_level(level: String):
	_default_log_level = level

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

# register a Logger instance with group ID
func register_logger(logger, group_id):
	# init a LoggerCollection for this logger
	if not _logger_collections.get(group_id, null):
		logger().debug("Creating LoggerCollection for group", "group_id", group_id)

		var lc = LoggerCollection.new()
		lc.set_name(group_id)
		lc.set_level(_default_log_level) # set the log level to the default

		_logger_collections[group_id] = lc 

	# add Logger instance to collection when it's a Logger
	if is_instance_of(logger, Logger):
		return _logger_collections[group_id].add_logger(logger)

	# copy an existing collection of Loggers
	elif typeof(logger) == TYPE_STRING:
		if _logger_collections.get(logger, null):
			for existing_logger in _logger_collections[logger]._loggers:
				_logger_collections[group_id].add_logger(existing_logger)

# deregister a Logger from a group
func deregister_logger(logger: Logger, group_id: String):
	return _logger_collections[group_id].remove_logger(logger)

# deregister collection of Logger instances
func delete_collection(group_id: String):
	return _logger_collections.erase(group_id)

# get a LoggerCollection instance
func get_collection(group_id):
	return _logger_collections.get(group_id, null)

# short access to get_collection()
func get(group_id):
	return get_collection(group_id)

# handle accessing collections as params
func _get(group_id):
	return get_collection(group_id)
