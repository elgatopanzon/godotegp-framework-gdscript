######################################################################
# @author      : ElGatoPanzon
# @class       : ConfigService
# @created     : Wednesday Sep 13, 2023 17:29:10 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service handling reading and writing config files
######################################################################

class_name ConfigService
extends Service

# path to look for configs in config locations
const CONFIG_FOLDER = "config"
const CONFIG_ROOT_PATHS = ["res://", "user://"] # order to look for config files in
const CONFIG_INIT_CLASSES = ["ConfigEngine"]

var _config_instances: Dictionary

# object constructor
func _init():
	# register instances for builtin configs
	for instance in CONFIG_INIT_CLASSES:
		register_config(instance)

	# load config data from file to replace defaults
	load_config_files()

func init():
	return self

# friendly name when printing object
func _to_string():
	return "ConfigService"

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

# register and create a config instance using short name, optionally providing override
func register_config(instance_type: String, config_resource = null):
	if not config_resource:
		config_resource = create_config_instance(instance_type)

	logger().debug("Registering config instance", "name", instance_type)

	# add the config resource
	_config_instances[instance_type] = config_resource

func create_config_instance(instance_type: String):
	var op = Services.ObjectPool.get_object_pool("DataResource%s" % instance_type)

	if not op:
		logger().critical("Invalid config instance type", "instance_type", instance_type)
		return false

	return op.instantiate()

func _get(config_instance):
	return get_config_instance(config_instance)

func get_config_instance(config_instance: String):
	if _config_instances.get(config_instance, null):
		return _config_instances[config_instance]
	else:
		logger().warning("Config instance doesn't exist", "config_instance", config_instance)

		return false


func load_config_files():
	for root_directory in CONFIG_ROOT_PATHS:
		var full_path = root_directory+CONFIG_FOLDER

		# check if the path exists
		var dir_exists = Services.Data.FS.exists(full_path)

		if not dir_exists:
			logger().debug("Config path doesn't exist", "path", full_path)

			continue

		# list directories to get config file types to load into
		var dir_contents = Services.Data.FS.ls(full_path)

		if dir_contents.size() == 0:
			logger().debug("Config path has no config sub-directories", "path", full_path)

			continue

		for item in dir_contents:
			var item_path = full_path+"/"+item
			if Services.Data.FS.isdir(item_path):
				# check if there's an instance already
				var instance_exists = (item in _config_instances)

				# let's see if it's actually valid
				var instance = null
				if not instance_exists:
					instance = create_config_instance(item)

					if instance:
						register_config(item, instance)
				else:
					instance = get_config_instance(item)
					instance.validate_data()

				# check if there's any config files to load from the directory
				var config_dir_contents_full = Services.Data.FS.ls(item_path)
				var config_dir_contents = []
				for file in config_dir_contents_full:
					var file_path = item_path+"/"+file
					if not Services.Data.FS.isdir(file_path):
						config_dir_contents.append(file_path)

				if config_dir_contents.size() == 0:
					logger().debug("Config sub-directory is empty", "item_path", item_path)

					continue

				# load found valid config files
				for config_item in config_dir_contents:
					var loaded_resource = Services.Data.load(Data.new(DataEndpointFile.new(config_item), create_config_instance(item)))

					# if the resource we got back is valid then the data was successfully validated and applied to the resource
					if loaded_resource:
						# merge resource with existing resource instance
						instance.merge_resource(loaded_resource)
