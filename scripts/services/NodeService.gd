######################################################################
# @author      : ElGatoPanzon
# @class       : NodeService
# @created     : Monday Sep 11, 2023 18:43:53 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service to manage Nodes in the scene by friendly ID
######################################################################

class_name NodeService
extends ServiceManagerService

var _nodes: Dictionary

var _signals_connected: bool = false

# object constructor
func _init():
	Services.Events.register_queue(EventQueue.new(self, 1)) # register instant queue

func init():
	return self

# friendly name when printing object
func _to_string():
	return "NodeService"

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
func _process(delta: float):
	# attempt to connect signals
	if not _signals_connected:
		logger().debug("Connected node listener signals")

		# subscribe to events
		Services.Events.subscribe(EventSubscription.new(self, EventNodeAdded))
		Services.Events.subscribe(EventSubscription.new(self, EventNodeRemoved))

		# connect signals
		get_tree().connect("node_added", Callable(self, "_on_node_added"))
		get_tree().connect("node_removed", Callable(self, "_on_node_removed"))

		_signals_connected = true

# called during physics processing
# func _physics_process(delta: float):
#	pass

# handle signals and forward to events for interested listeners
func _on_node_added(node: Node):
	Services.Events.emit_now(EventNodeAdded.new(self, node), self)
func _on_node_removed(node: Node):
	Services.Events.emit_now(EventNodeRemoved.new(self, node), self)

# receive events from above
func _on_EventNodeAdded(event):
	logger().debug("Node added to scene tree", "node", event.get_node())
func _on_EventNodeRemoved(event):
	logger().debug("Node removed frome scene tree", "node", event.get_node())
