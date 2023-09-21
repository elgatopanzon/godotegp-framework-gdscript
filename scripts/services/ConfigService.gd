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
func _init(name: String):
	set_name(name)

	# register instances for builtin configs
	for instance in CONFIG_INIT_CLASSES:
		register_config(instance)

	# load config data from file to replace defaults
	var load_r = load_config_files()

	if not load_r.SUCCESS:
		logger().debug("Config load error", "error", load_r.error.to_dict())

		for cerror in load_r.error.get_errors():
			logger().debug("Config load child error", "error", cerror.to_dict())

			for ccerror in cerror.get_errors():
				logger().debug("Config load child child error", "error", ccerror.to_dict())

	set_ready()

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
func register_config(instance_type: String, config_resource: DataResource = null):
	if not config_resource:
		var r = create_config_instance(instance_type)

		if not r.SUCCESS:
			return r
		else:
			config_resource = r.value

	logger().debug("Registering config instance", "name", instance_type)

	# add the config resource
	_config_instances[instance_type] = config_resource

	return Result.new(true)

func create_config_instance(instance_type: String):
	var op = Services.ObjectPool.get_object_pool("DataResource%s" % instance_type)

	if not op:
		logger().warning("Invalid config instance type", "instance_type", instance_type)

		return Result.new(false, ResultError.new(self, "invalid_config_instance_type", {"instance_type": instance_type}))

	return Result.new(op.instantiate())

func _get(config_instance):
	return get_config_instance(config_instance)

func get_config_instance(config_instance: String):
	if _config_instances.get(config_instance, null):
		return _config_instances[config_instance]
	else:
		logger().warning("Config instance doesn't exist", "config_instance", config_instance)

		# this is fine, it either exists or it doesn't
		return null


func load_config_files():
	var load_config_errors = []

	for root_directory in CONFIG_ROOT_PATHS:
		var full_path = root_directory+CONFIG_FOLDER

		# check if the path exists
		var dir_exists = Services.Data.FS.exists(full_path)

		# check for errors
		if not dir_exists.SUCCESS:
			load_config_errors.append(dir_exists.error)

		# if the dir doesn't exist, skip the path
		if not dir_exists.value:
			logger().debug("Config path doesn't exist", "path", full_path)

			continue

		# list directories to get config file types to load into
		var dir_contents = Services.Data.FS.ls(full_path)

		if not dir_contents.SUCCESS:
			load_config_errors.append(dir_contents.error)
		else:
			dir_contents = dir_contents.value

		# ignore empty directory
		if dir_contents.size() == 0:
			logger().debug("Config path has no config sub-directories", "path", full_path)

			continue
		else:
			logger().debug("Config path has sub-directories", "path", full_path)

		for item in dir_contents:
			var item_path = full_path+"/"+item

			logger().debug("Searching sub-directory", "path", item_path)

			var isdir = Services.Data.FS.isdir(item_path)

			if not isdir.SUCCESS:
				logger().debug("Searching sub-directory error", "error", isdir.error.to_dict())

				load_config_errors.append(isdir.error)

			isdir = isdir.value

			if isdir:
				logger().debug("Item is directory, searching for config files", "path", item_path)

				# check if there's an instance already
				var instance_exists = (item in _config_instances)

				# let's see if it's actually valid
				var instance = null
				if not instance_exists:
					var result = create_config_instance(item)

					if result.SUCCESS:
						instance = result.value
						register_config(item, instance)
					else:
						load_config_errors.append(result.error)
				else:
					instance = get_config_instance(item)
					var result = instance.validate_data()

					if not result.SUCCESS:
						load_config_errors.append(result.error)

				# check if there's any config files to load from the directory
				var config_dir_contents_full = Services.Data.FS.ls(item_path)

				if not config_dir_contents_full.SUCCESS:
					logger().debug("Config sub-directory ls error", "error", config_dir_contents_full.error.to_dict())

					load_config_errors.append(config_dir_contents_full.error)

					continue

				config_dir_contents_full = config_dir_contents_full.value
				var config_dir_contents = []
				for file in config_dir_contents_full:
					var file_path = item_path+"/"+file

					var isdir_f = Services.Data.FS.isdir(file_path)

					if not isdir_f.SUCCESS:
						load_config_errors.append(isdir_f.error)

					isdir_f = isdir_f.value

					if not isdir_f:
						logger().debug("Possible config file found", "path", file_path)
						config_dir_contents.append(file_path)

				if config_dir_contents.size() == 0:
					logger().debug("Config sub-directory is empty", "item_path", item_path)

					continue

				# load found valid config files
				for config_item in config_dir_contents:
					var load_instance = create_config_instance(item)

					if load_instance.SUCCESS:
						var load_r = Services.Data.load(Data.new(DataEndpointFile.new(config_item), load_instance.value))

						# if the resource we got back is valid then the data was successfully validated and applied to the resource
						if not load_r.SUCCESS:
							logger().debug("Config item instance creation error", "error", load_r.error.to_dict())

							load_config_errors.append(load_r.error)

							continue

						logger().debug("Config item base instance created", "config_item", config_item)

						var loaded_resource = load_r.value

						# merge resource with existing resource instance
						var merge_r = instance.merge_resource(loaded_resource)
						if not merge_r.SUCCESS:
							load_config_errors.append(merge_r.error)

							continue
					else:
						load_config_errors.append(load_instance.error)

	# handle any errors
	if load_config_errors.size() > 0:
		var error = ResultError.new(self, "load_config_errors")
		for e in load_config_errors:
			error.add_error(e)

		return Result.new(false, error)
	else:
		return Result.new(true)

# get a property from a config resource, returning a default value if it doesn't exist
func get_instance_property(config_name: String, prop: String, default = null):
	var instance = get_config_instance(config_name)
	if instance:
		return instance.get(prop, default)
	else:
		return default
