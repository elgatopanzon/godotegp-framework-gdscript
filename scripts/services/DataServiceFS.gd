######################################################################
# @author      : ElGatoPanzon
# @class       : DataServiceFS
# @created     : Wednesday Sep 13, 2023 20:01:55 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Service offering filesystem operations
######################################################################

class_name DataServiceFS
extends Service

# object constructor
func _init(name: String):
	set_name(name)

	set_ready()

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataServiceFS"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

# shortcuts to directory operations using DataEndpointDir
func get_data_endpoint_dir(path: String):
	# create an endpoint with the given path
	var endpoint = Services.ObjectPool.DataEndpointDir.instantiate([path])

	return endpoint

# list contents of directory
func ls(path: String, include_hidden: bool = true):
	if dir_exists(path).value == false:
		return Result.new(false, ResultError.new(self, "dir_not_found", {"path": path}))

	var endpoint = get_data_endpoint_dir(path)

	if not endpoint.is_valid():
		var error = ResultError.new(self, "endpoint_error", {"path": path, "method": "ls"})
		error.add_error(endpoint._dir_open_error)
		return Result.new(false, error)

	endpoint._dir_object.include_hidden = include_hidden

	# returns upstream Result object
	return endpoint.list()

# check if file or dir exists
func exists(path: String):
	if FileAccess.file_exists(path):
		return Result.new(true)

	if DirAccess.dir_exists_absolute(path):
		return Result.new(true)

	return Result.new(false)

func dir_exists(path: String):
	if not FileAccess.file_exists(path) and DirAccess.dir_exists_absolute(path):
		return Result.new(true)

	return Result.new(false)


func isdir(path: String):
	if dir_exists(path).value == true and exists(path).value == true:
		return Result.new(true)
	else:
		return Result.new(false)

	# var endpoint = get_data_endpoint_dir(path)
	#
	# if not endpoint.is_valid():
	# 	var error = ResultError.new(self, "endpoint_error", {"path": path, "method": "isdir"})
	# 	error.add_error(endpoint._dir_open_error)
	# 	return Result.new(false, error)
	#
	# return endpoint.isdir()

# make directory
func mkdir(path: String, recursive: bool = false):
	var result = false

	if recursive:
		result = DirAccess.make_dir_recursive_absolute(path)
	else:
		result = DirAccess.make_dir_absolute(path)

	if result != OK:
		var error = Services.Events.error(self, result, {"path": path, "error_no": result})

		return Result.new(false, error)

	return Result.new(true)

# remove directory or file
func rm(path: String):
	var result = DirAccess.remove_absolute(path)

	if result != OK:
		var error = Services.Events.error(self, result, {"path": path, "error_no": result})

		return Result.new(false, error)

	return Result.new(true)

# rename directory or file to another name
func mv(from_path: String, to_path: String):
	var result = DirAccess.rename_absolute(from_path, to_path)

	if result != OK:
		var error = Services.Events.error(self, result, {"from": from_path, "to": to_path, "error_no": result})

		return Result.new(false, error)

	return Result.new(true)

# copy directory or file to another location
func cp(from_path: String, to_path: String):
	var result = DirAccess.copy_absolute(from_path, to_path)

	if result != OK:
		var error = Services.Events.error(self, "copy_failed", {"from": from_path, "to": to_path, "error_no": result})

		return Result.new(false, error)

	return Result.new(true)
