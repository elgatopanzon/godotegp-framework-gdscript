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

var _previous_ms = 0

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

func process_value(value, value_original):
	value = process(value, value_original)

	if self._logger_line_current > 1:
		return "[bgcolor=black][fgcolor=black]%s[/fgcolor][/bgcolor]" % [value]
	else:
		return value

func process(value, value_original):
	var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

	var current_time = get_destination_owner()._line_time
	if not current_time:
		current_time = Time.get_datetime_dict_from_system()
	return "[%s] %s %s %s %s:%s:%s" % [get_engine_ticks(), str(current_time.day).pad_zeros(2), months[current_time.month], current_time.year, str(current_time.hour).pad_zeros(2), str(current_time.minute).pad_zeros(2), str(current_time.second).pad_zeros(2)]

func get_engine_ticks():
	var prev = _previous_ms
	var tick = Time.get_ticks_msec()

	var diff_str = "+"

	var tick_diff = ceil(tick - prev)
	if prev == 0:
		tick_diff = 0

	var ms = str(tick)
	ms.erase(ms.length() - 1, 1)
	var timestamp = str(tick/3600000).pad_zeros(2)+":"+str(tick/60000).pad_zeros(3)+":"+str(tick/1000).pad_zeros(4)+"."+ms.pad_zeros(8)+" "+diff_str+str(tick_diff).pad_zeros(3)

	_previous_ms = tick
	return timestamp
