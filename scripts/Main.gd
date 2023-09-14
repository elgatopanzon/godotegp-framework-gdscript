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

var _services: Dictionary = {
	"Log": LoggerService, # init first so other services can use it
	"ObjectPool": ObjectPoolService,
	"DataFS": DataServiceFS, # init first so other services can use it
	"Data": DataService, # init first so other services can use it
	"Config": ConfigService,
	"System": SystemService,
	"Random": RandomService,
	"Events": EventService,
	"Nodes": NodeService,
}

func to_string():
	return "GodotEGP.Main"

func logger():
	return Services.Log.get(self.to_string())


# object constructor
func _init():
	# init and register services
	for service in _services:
		Services.register_service(_services[service].new(), service)

	# set default log level
	Services.Log.set_default_log_level("debug")

	# # logging test using self as group
	# Services.Log.register_logger("default", self)
	# Services.Log.get(self).set_level("debug")

	# Services.Log.get(self).debug("log test debug")
	# Services.Log.get(self).info("log test info but a really longgg message so I can try to split it by word", "varname", {"test_key": "test_value"})
	# Services.Log.get(self).warning("log test warning")
	# Services.Log.get(self).error("log test error")
	# Services.Log.get(self).critical("log test critical", "bigdict", {"some_fairly_large_dict": "value", "another_val": 123})

	# var node_test = Node2D.new()
	# Services.Log.register_logger("default", node_test)
	# Services.Log.get(node_test).set_level("debug")
	# Services.Log.get(node_test).debug("log test debug")

	# test auto creating loggers
	# Services.Log.register_logger("default", "Test")
	# Services.Log.Test.debug("log test debug")

	# Services.Log.Test.debug("order test 1")
	# Services.Log.Test.debug("order test 2")
	# Services.Log.Test.debug("order test 3")
	# Services.Log.Test.debug("order test 4")
	# Services.Log.Test.debug("order test 5")
	# Services.Log.Test.debug("order test 6")
	# Services.Log.Test.debug("order test 7")
	# Services.Log.Test.debug("order test 8")
	# Services.Log.Test.debug("order test 9")
	# Services.Log.Test.debug("order test 10")

	# test event
	# Services.Events.emit(EventBasic.new(self, "was emitted using emit()"))
	# Services.Events.emit_now(EventBasic.new(self, "was emitted using emit_now()"))
	# Services.Events.emit_once(EventBasic.new(self, "was emitted using emit_once()"))
	# Services.Events.emit_now_once(EventBasic.new(self, "was emitted using emit_now_once()"))
	# Services.Events.emit_wait(EventBasic.new(self, "was emitted using emit_wait()"))

	# event fetch test
	# Services.Events.emit_wait(EventBasic.new(self, "fetch test 1"))
	# Services.Events.emit_wait(EventBasic.new(self, "fetch test 2"))
	# Services.Events.emit_wait(EventTest.new(self))

	# var fetched = Services.Events.fetch(EventBasic) # fetch all waiting EventBasic events
	# Services.Log.Test.debug("fetch 1", "fetched", fetched)
	# fetched = Services.Events.fetch_all(EventBasic) # fetch again all waiting EventBasic events
	# Services.Log.Test.debug("fetch all", "fetched", fetched)

	# fetched = Services.Events.fetch(EventTest) # fetch again all waiting EventBasic events
	# Services.Log.Test.debug("fetch 1 (but it should match EventTest)", "fetched", fetched)

	# subscribe and broadcast test
	# Services.Events.subscribe(EventSubscription.new(self))
	# Services.Events.subscribe(EventSubscription.new(self, EventTest))
	# Services.Events.emit_now(EventBasic.new(self, "sub test 1"))
	# Services.Events.emit_now(EventTest.new(self))
	# Services.Events.emit_now_once(EventTest.new(self))
	# Services.Events.emit(EventTest.new(self)) # deferred test

	# custom event queue
	# Services.Events.register_queue(EventQueue.new("custom", 2)) # 2 = deferred
	# Services.Events.subscribe(EventSubscription.new(self, EventTest))

	# Services.Events.custom.queue(EventTest.new(self))

	# unsubscribe test
	# Services.Events.unsubscribe(self) # unsubscribe all subscriptions for self
	# Services.Events.emit_now(EventTest.new(self)) # shouldn't go to anyone

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

# func _on_EventBasic(event: Event):
# 	Services.Log.Test.debug("Received broadcasted EventBasic event", "event", event.to_dict())
# func _on_EventTest(event: Event):
# 	Services.Log.Test.debug("Received broadcasted EventTest event", "event", event.to_dict())
