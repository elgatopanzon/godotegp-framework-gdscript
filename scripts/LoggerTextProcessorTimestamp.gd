######################################################################
# @author      : ElGatoPanzon
# @class       : LoggerTextProcessorTimestamp
# @created     : Saturday Sep 09, 2023 20:52:31 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Render the current timestamp
######################################################################

class_name LoggerTextProcessorTimestamp
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
	var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

	var current_time = Time.get_datetime_dict_from_system()
	return "[%s] %s %s %s %s:%s:%s" % [get_engine_ticks(), str(current_time.day).pad_zeros(2), months[current_time.month], current_time.year, str(current_time.hour).pad_zeros(2), str(current_time.minute).pad_zeros(2), str(current_time.second).pad_zeros(2)]

func get_engine_ticks():
	var tick = Time.get_ticks_msec()
	var ms = str(tick)
	ms.erase(ms.length() - 1, 1)
	var timestamp = str(tick/3600000)+":"+str(tick/60000).pad_zeros(2)+":"+str(tick/1000).pad_zeros(2)+"."+ms
	return timestamp
