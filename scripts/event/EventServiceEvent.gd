######################################################################
# @author      : ElGatoPanzon
# @class       : EventServiceEvent
# @created     : Sunday Sep 10, 2023 19:34:46 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base class for EventService events
######################################################################

class_name EventServiceEvent
extends Event

# event data
var _owner
var _service_name

# object constructor
func _init(owner: Object, service_name: String):
	_owner = owner
	_service_name = service_name

func init():
	return self

func _to_string():
	return "EventServiceEvent"

func to_dict():
	return {
		"single_consume": _single_consume,
		"owner": _owner,
		"service_name": _service_name,
	}

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass
