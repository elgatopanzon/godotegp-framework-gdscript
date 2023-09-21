######################################################################
# @author      : ElGatoPanzon
# @class       : Service
# @created     : Friday Sep 08, 2023 17:05:13 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Base class for implementing a Service for the ServiceManager
######################################################################

class_name Service
extends Node

var _name: String

# holds service ready state
var _ready: bool = false

# object constructor
func _init(name: String):
	set_name(name)

	set_ready(true)

func get_ready():
	return _ready
func set_ready(state: bool = true):
	# execute on_ready
	if state == true and _ready != true:
		on_ready()

	_ready = state

func get_name():
	return _name
func set_name(name: String):
	_name = name


func set_ready_once():
	if not get_ready():
		set_ready()

# scene lifecycle methods
# called when node enters the tree
# func _enter_tree():
# 	pass

# called once when node is ready
# func _ready():
# 	pass

# called when node exits the tree
# func _exit_tree():
# 	pass


# process methods
# called during main loop processing
# func _process(delta: float):
# 	pass

# called during physics processing
# func _physics_process(delta: float):
# 	pass

# called when service has been registered
func on_registered():
	pass

# called when service has been deregistered
func on_deregistered():
	pass

func on_ready():
	# emit service ready event
	Services.register_delayed_service_call("Events", Callable(self, "_on_EventServiceRegistered_Events"))

func _on_EventServiceRegistered_Events(event: Event = null):
	Services.Events.emit_now(EventServiceReady.new(self, self.get_name()))
