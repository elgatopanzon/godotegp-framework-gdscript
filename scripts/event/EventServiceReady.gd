######################################################################
# @author      : ElGatoPanzon
# @class       : EventServiceReady
# @created     : Sunday Sep 10, 2023 19:34:46 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Event for service ready
######################################################################

class_name EventServiceReady
extends EventServiceEvent

# object constructor
func _init(owner: Object, service_name: String):
	_owner = owner
	_service_name = service_name

func _to_string():
	return "EventServiceReady"
