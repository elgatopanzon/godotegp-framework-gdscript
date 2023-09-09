######################################################################
# @author      : ElGatoPanzon
# @class       : Main
# @created     : Friday Sep 08, 2023 18:07:54 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Main script for controlling the framework
######################################################################

class_name Main
extends Node

# object constructor
func _init():
	# init and register services
	Services.register_service(ServiceManagerService.new(), "Test")


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

