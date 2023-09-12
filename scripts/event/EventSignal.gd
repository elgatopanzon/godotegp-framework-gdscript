######################################################################
# @author      : ElGatoPanzon
# @class       : EventSignal
# @created     : Monday Sep 11, 2023 14:01:33 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Event containing a signal with optional param
######################################################################

class_name EventSignal
extends Event

var _owner: Object
var _signal_name: String
var _signal_data

# object constructor
func _init(owner: Object, signal_name: String, signal_data):
	_owner = owner
	_signal_name = signal_name
	_signal_data = signal_data

func init():
	return self

func as_dict():
	return {
		"single_consume": _single_consume,
		"owner": _owner,
		"signal": _signal_name,
		"data": _signal_data,
	}

# friendly name when printing object
func _to_string():
	return "EventSignal"

func get_broadcast_method_string():
	return _to_string()+"_"+_signal_name

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

