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

# register a Logger instance with group ID
func register_logger(logger: Logger, group_id):
	# init a LoggerCollection for this logger
	if not _logger_collections.get(group_id, null):
		print("Creating LoggerCollection for group: %s" % [group_id])
		var lc = LoggerCollection.new()
		lc.set_name(group_id)

		_logger_collections[group_id] = lc 

	# add Logger instance to collection
	return _logger_collections[group_id].add_logger(logger)

# deregister a Logger from a group
func deregister_logger(logger: Logger, group_id: String):
	return _logger_collections[group_id].remove_logger(logger)

# deregister collection of Logger instances
func delete_collection(group_id: String):
	return _logger_collections.erase(group_id)

# get a LoggerCollection instance
func get_collection(group_id):
	return _logger_collections.get(group_id, null)

# handle accessing collections as params
func _get(group_id):
	return get_collection(group_id)
