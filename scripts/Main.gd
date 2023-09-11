######################################################################
# @author      : ElGatoPanzon
# @class       : Main
# @created     : Friday Sep 08, 2023 18:07:54 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Main script for controlling the framework
######################################################################

class_name GodotEGPFramework
extends Node

# object constructor
func _init():
	# init and register services
	# logging
	Services.register_service(LoggerService.new(), "Log")

	Services.Log.set_default_log_level("debug")

	# object pool
	Services.register_service(ObjectPoolService.new(), "ObjectPool")

	# logging test using self as group
	Services.Log.register_logger("default", self)
	Services.Log.get(self).set_level("debug")

	Services.Log.get(self).debug("log test debug")
	Services.Log.get(self).info("log test info but a really longgg message so I can try to split it by word", "varname", {"test_key": "test_value"})
	Services.Log.get(self).warning("log test warning")
	Services.Log.get(self).error("log test error")
	Services.Log.get(self).critical("log test critical", "bigdict", {"some_fairly_large_dict": "value", "another_val": 123})

	var node_test = Node2D.new()
	Services.Log.register_logger("default", node_test)
	Services.Log.get(node_test).set_level("debug")
	Services.Log.get(node_test).debug("log test debug")

	# test auto creating loggers
	# Services.Log.register_logger("default", "Test")
	Services.Log.Test.debug("log test debug")

	# event service
	Services.register_service(EventService.new(), "Events")

	# test event
	Services.Events.emit(EventBasic.new(self, "was emitted using emit()"))
	Services.Events.emit_now(EventBasic.new(self, "was emitted using emit_now()"))
	Services.Events.emit_once(EventBasic.new(self, "was emitted using emit_once()"))
	Services.Events.emit_now_once(EventBasic.new(self, "was emitted using emit_now_once()"))
	Services.Events.emit_wait(EventBasic.new(self, "was emitted using emit_wait()"))

	# event fetch test
	Services.Events.emit_wait(EventBasic.new(self, "fetch test 1"))
	Services.Events.emit_wait(EventBasic.new(self, "fetch test 2"))
	Services.Events.emit_wait(EventTest.new(self))

	var fetched = Services.Events.fetch(EventBasic) # fetch all waiting EventBasic events
	Services.Log.Test.debug("fetch 1", "fetched", fetched)
	fetched = Services.Events.fetch_all(EventBasic) # fetch again all waiting EventBasic events
	Services.Log.Test.debug("fetch all", "fetched", fetched)

	fetched = Services.Events.fetch(EventTest) # fetch again all waiting EventBasic events
	Services.Log.Test.debug("fetch 1 (but it should match EventTest)", "fetched", fetched)

	# subscribe and broadcast test
	Services.Events.subscribe(EventSubscription.new(self))
	Services.Events.subscribe(EventSubscription.new(self, EventTest))
	Services.Events.emit_now(EventBasic.new(self, "sub test 1"))
	Services.Events.emit_now(EventTest.new(self))
	Services.Events.emit_now_once(EventTest.new(self))
	Services.Events.emit(EventTest.new(self)) # deferred test

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

func get_logger_name():
	return "GodotEGP.Main"

func _on_EventBasic(event: Event):
	Services.Log.Test.debug("Received broadcasted EventBasic event", "event", event.as_dict())
func _on_EventTest(event: Event):
	Services.Log.Test.debug("Received broadcasted EventTest event", "event", event.as_dict())
