######################################################################
# @author      : ElGatoPanzon
# @class       : ObjectPoolService
# @created     : Friday Sep 08, 2023 18:47:24 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service to manage instances of ObjectPool on per-class/per-scene basis
######################################################################

class_name ObjectPoolService
extends ServiceManagerService

var object_pools: Dictionary

# object constructor
func _init():
	Services.Log.register_logger("default", self.to_string())

func logger():
	return Services.Log.get(self.to_string())

func _to_string():
	return "ObjectPoolService"

	pass


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

# handle accessing ObjectPool instances by class name
func _get(class_instance_name):
	return get_object_pool(class_instance_name)

# return or create an instance of an ObjectPool for a class
func get_object_pool(class_instance_name):
	var object_pool_instance = object_pools.get(class_instance_name, null)

	# check if the instance is not valid, we must create it
	if not object_pool_instance:
		object_pool_instance = create_object_pool_instance(class_instance_name)

		# if we instanced a valid pool, register it
		if object_pool_instance:
			register_object_pool(object_pool_instance, class_instance_name)
	return object_pool_instance

# set the ObjectPool instance for the class name
func register_object_pool(object_pool: ObjectPool, class_instance_name: String):
	object_pools[class_instance_name] = object_pool

# check if class_name has ObjectPool implementation
func get_class_info(class_instance_name: String):
	var global_class_list = ProjectSettings.get_global_class_list()

	# if a class name matches the string provided, return true
	for global_class_data in global_class_list:
		if global_class_data['class'] == class_instance_name:
			return global_class_data

# create an ObjectPool instance for a class name
func create_object_pool_instance(class_instance_name: String):
	# fetch any custom class object pool class
	var custom_class_object_pool_info = get_class_info(class_instance_name+"ObjectPool")

	# if the class is a built-in class, we can create an instance easily
	if ClassDB.can_instantiate(class_instance_name):
		logger().debug("creating ObjectPool", "class", class_instance_name)

		# for now, no builtin class supports required _init() params so a basic ObjectPool instance will do
		# if custom_class_object_pool_info:
		#	  logger().debug("ObjectPool custom class found", "class", class_instance_name)
		#
		# 	return load(custom_class_object_pool_info.get('path')).new(class_instance_name)
		# else:
		# 	return ObjectPool.new(class_instance_name)

		return ObjectPool.new(class_instance_name)

	# if not, let's check if it's a custom class
	else:
		var custom_class_info = get_class_info(class_instance_name)

		# valid custom class
		if custom_class_info:
			logger().debug("creating ObjectPool", "class", class_instance_name)

			if custom_class_object_pool_info:
				logger().debug("ObjectPool custom class found", "class", class_instance_name)

				return load(custom_class_object_pool_info.get('path')).new(class_instance_name, custom_class_info.get('base'), custom_class_info.get('path'))
			else:
				return ObjectPool.new(class_instance_name, custom_class_info.get('base'), custom_class_info.get('path'))

		# not custom class or built-in
		else:
			logger().critical("not valid class", "class", class_instance_name)

			return null
