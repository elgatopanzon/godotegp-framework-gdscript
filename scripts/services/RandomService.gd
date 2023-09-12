######################################################################
# @author      : ElGatoPanzon
# @class       : RandomService
# @created     : Tuesday Sep 12, 2023 12:37:17 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service offering RandomNumberGenerator functionality
######################################################################

class_name RandomService
extends ServiceManagerService

var _rng_instances: Dictionary

# object constructor
func _init():
	init_default_rng()

func init():
	return self

func init_default_rng():
	register_rng(get_new_rng(), "default")

func get_default_rng():
	return get_rng("default")

func get_rng(name):
	return _rng_instances.get(name, null)

# friendly name when printing object
func _to_string():
	return "RandomService"

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

# register new RNG
func register_rng(rng: RandomNumberGeneratorExtended, name):
	logger().debug("Registering RNG instance", "rng", {"name": name, "rng": rng.to_dict()})
	_rng_instances[name] = rng

func get_new_rng(seed: int = 0, state: int = 0):
	var rng = RandomNumberGeneratorExtended.new()

	return rng

func create_rng(name, seed: int = 0, state: int = 0):
	register_rng(get_new_rng(seed, state), name)

	return get_rng(name)

func _get(rng_name):
	return get_rng(rng_name)
