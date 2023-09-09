######################################################################
# @author      : ElGatoPanzon
# @class       : ObjectPool
# @created     : Friday Sep 08, 2023 19:20:18 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Implementation of an Object Pool
#                Stores a "pool" of objects, returns instance
#                If no instances exist, instantiate a new one
######################################################################

class_name ObjectPool
extends Node

# info about the class
var _primary_class: String
var _base_class: String
var _script_path: String

# pool of objects
var _object_pool: Array[Object]

# object constructor takes info about the class
func _init(primary_class: String, base_class: String = "", script_path: String = ""):
	_primary_class = primary_class
	_base_class = base_class
	_script_path = script_path


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

# return or instance a new object
func instantiate():
	return get_or_create_instance()

# create an ininstantiated instance of an object
func get_or_create_instance():
	if _object_pool.size() > 0:
		return _object_pool.pop_front()
	else:
		if is_custom_class(): 
			# it's a scene or a custom class
			# return it uninstanced
			var instance = load(_script_path).new()

			# call request_ready() on used object
			if instance.has_method("request_ready"):
				instance.request_ready()

			return instance
		else: 
			# it's a builtin class
			var instance = ClassDB.instantiate(_primary_class)

			# call prepare() on object first time instancing it
			if instance.has_method("prepare"):
				instance.prepare()

			return instance

# put a used object back into the pool
func return_instance(obj: Object):
	_object_pool.push_back(obj)

# check if the class is custom or builtin
# if there's a script path then it's a custom class
func is_custom_class():
	return len(_script_path) > 0
