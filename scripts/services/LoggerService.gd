######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerService
# @created     : Friday Sep 08, 2023 22:20:40 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service to log to a collection of Loggers
######################################################################

class_name LoggerService
extends Service

# holds queue of logs to process (hacky)
var _logger_event_queue: Array[EventLoggerLine]
var _logger_event_queue_process_max = 1

# hold the LoggerCollection instances
var _logger_collections: Dictionary

var _default_log_level: String

# object constructor
func _init(default_log_level: String = "debug"):
	set_default_log_level(default_log_level)

	# create self LoggerCollection to allow us to log from here as early as possible
	create_logger_collection(self.to_string(), _default_log_level)

	# setup default loggers
	var logger_console = Logger.new()
	var logger_destination_console = LoggerDestinationConsole.new()
	logger_console.add_destination(logger_destination_console)

	# add all the default LoggerTextBlocks for this type of destination
	logger_destination_console.setup_default_text_blocks()

	# add logger as reusable collection
	self.register_logger(logger_console, "default")

	self.register_logger("default", self.to_string())

func logger():
	return self.get(self.to_string())

func _to_string():
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
func _process(delta: float):
	# process the queue
	var counter = 0
	while _logger_event_queue.size() > 0 and counter < _logger_event_queue_process_max:
		var event = _logger_event_queue.pop_front()

		event.get_logger_collection().process_event(event)

		counter += 1

# called during physics processing
# func _physics_process(delta: float):
#	pass

func create_logger_collection(group_id, level):
	var lc = LoggerCollection.new()
	lc.set_name(group_id)
	lc.set_level(level) # set the log level to the default

	_logger_collections[group_id] = lc 

	return lc

# register a Logger instance with group ID
func register_logger(logger, group_id):
	# init a LoggerCollection for this logger
	if not _logger_collections.get(group_id, null):
		logger().debug("Creating LoggerCollection for group", "group_id", group_id)

		create_logger_collection(group_id, _default_log_level)

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
func get_collection(group_id, auto_create_from: String = "default"):
	var logger_collection = _logger_collections.get(group_id, null)

	# allow dynamic creation of LoggerCollection when using String group_id
	# note: defaults to "default" and depends on it being registered
	if auto_create_from != "" and not logger_collection and typeof(str(group_id)) == TYPE_STRING:
		if get_collection(auto_create_from, ""):
			register_logger(auto_create_from, str(group_id))
			logger_collection = get_collection(str(group_id))

	return logger_collection

# short access to get_collection()
func get(group_id):
	return get_collection(group_id)

# handle accessing collections as params
func _get(group_id):
	return get_collection(group_id)

# accept an EventLoggerLine object to queue
func queue_logging_event(event: EventLoggerLine):
	_logger_event_queue.append(event)
