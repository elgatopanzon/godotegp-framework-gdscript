######################################################################
# @author      : ElGatoPanzon
# @class       : RandomNumberGeneratorExtended
# @created     : Tuesday Sep 12, 2023 12:54:00 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Extended version of RandomNumberGenerator class
######################################################################

class_name RandomNumberGeneratorExtended
extends RandomNumberGenerator

var _initial_seed: int = 0
var _initial_state: int = 0

# object constructor
func _init(_seed: int = 0, _state: int = 0):
	_initial_seed = _seed
	_initial_state = _state

	self.seed = _seed

	if _state != 0:
		self.state = _state
	else:
		self.randomize()

# friendly name when printing object
func _to_string():
	return "RandomNumberGeneratorExtended"

func to_dict():
	return {
		"seed": self.seed,
		"state": self.state,
		"initial_seed": self._initial_seed,
		"initial_state": self._initial_state,
	}

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

