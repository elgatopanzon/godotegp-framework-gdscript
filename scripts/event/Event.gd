######################################################################
# @author      : ElGatoPanzon
# @class       : Event
# @created     : Sunday Sep 10, 2023 17:33:41 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base Event resource
######################################################################

class_name Event
extends Resource

# if true, the event will only be consumed once
var _single_consume: bool = false

# object constructor
func init():
	return self

# used by LoggerService
func _to_string():
	return "Event"

func to_string():
	return "dummy event"

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

# object destructor
# func _notification(what):
#     if (what == NOTIFICATION_PREDELETE):
#         pass

func set_single_consume(state: bool):
	_single_consume = state

func get_single_consume():
	return _single_consume
