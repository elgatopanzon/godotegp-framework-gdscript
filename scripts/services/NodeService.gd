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

var _signal_connections: Dictionary

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

		# fetch all children and add them
		add_scene_tree_nodes()

		_signals_connected = true

func add_scene_tree_nodes():
	for node in get_all_scene_tree_nodes():
		if get_node_id(node):
			_on_node_added(node)

func get_all_scene_tree_nodes(node = get_tree().root, all_nodes = []):
	all_nodes.append(node)
	for chid_node in node.get_children():
		get_all_scene_tree_nodes(chid_node, all_nodes)
	return all_nodes

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

	register_node(event.get_node(), str(get_node_id(event.get_node())))

func _on_EventNodeRemoved(event):
	logger().debug("Node removed frome scene tree", "node", event.get_node())

	unregister_node(get_node_id(event.get_node()), event.get_node())

# register node
func register_node(node: Node, node_id: String, register_groups: bool = true):
	if not _nodes.get(node_id, null):
		_nodes[node_id] = []

	# add newest node to the stack if it's not already in this stack
	if not node in _nodes[node_id]:
		_nodes[node_id].push_front(node)

	# register node using it's groups as ID
	if register_groups:
		register_node_groups(node)

	# connect delayed signals to nodes
	connect_delayed_signals(node_id)

# register a node using all it's groups
func register_node_groups(node):
	for group in node.get_groups():
		register_node(node, "group_%s" % str(group), false)

# unregister node
func unregister_node(node_id, node):
	_nodes.get(node_id).erase(node)

# get the friendly ID of a node
func get_node_id(node):
	# get ID from meta
	if node.has_meta("id"):
		return node.get_meta("id")
	else:
		return node.get_name()

# get registered nodes
func get_registered_node(node_id: String):
	return _nodes.get(node_id, false)

func _get(node_id):
	return get_registered_node(node_id)

func get_all_registered_nodes():
	return _nodes

# subscribe to an event of a signal on an existing or delayed added node
func subscribe_signal(node_id: String, signal_name: String, subscription: EventSubscription):
	# add custom callable if one isn't already defined
	if not subscription.get_subscriber_callable():
		subscription.set_subscriber_callable(Callable(subscription.get_subscriber(), "_on_%s__EventSignal_%s" % [node_id, signal_name]))

	var delayed_signal_dict = get_delayed_signal_dict(node_id, signal_name, subscription)

	# add the subscription if it doesn't already exist
	if not _signal_connections.get(node_id, null):
		_signal_connections[node_id] = []

	if not delayed_signal_dict in _signal_connections.get(node_id):
		_signal_connections.get(node_id).push_back(delayed_signal_dict)

	# connect delayed signals to existing nodes
	connect_delayed_signals(node_id)

func get_delayed_signal_dict(node_id: String, signal_name: String, subscription: EventSubscription):
	return {
		"node_id": node_id,
		"signal_name": signal_name,
		"subscription": subscription,
	}

func connect_delayed_signals(node_id: String):
	if _signal_connections.get(node_id, null):
		for signal_connection in _signal_connections[node_id]:
			if get_registered_node(node_id):
				logger().debug("Subscribing to node_id signal", "signal_connection", signal_connection)

				for node in get_registered_node(node_id): 
					var duplicate_subscription = EventSubscription.new(signal_connection.subscription._subscriber, signal_connection.subscription._event_type, signal_connection.subscription._event_filters.duplicate(), signal_connection.subscription._subscriber_callable)

					Services.Events.subscribe_signal(node, signal_connection.signal_name, duplicate_subscription)
