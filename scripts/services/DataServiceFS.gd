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
func _init():
	pass

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
	var endpoint = Services.ObjectPool.DataEndpointDir.instantiate([path])

	if not endpoint.is_valid():
		return false
	else:
		return endpoint

# list contents of directory
func ls(path: String, include_hidden: bool = true):
	var endpoint = get_data_endpoint_dir(path)

	if not endpoint:
		return false

	endpoint._dir_object.include_hidden = include_hidden

	return endpoint.list()

# check if file or dir exists
func exists(path: String):
	if FileAccess.file_exists(path):
		return true

	return isdir(path)

func isdir(path: String):
	var endpoint = get_data_endpoint_dir(path)

	if not endpoint:
		return false

	return endpoint.isdir()

# make directory
func mkdir(path: String, recursive: bool = false):
	var result = false

	if recursive:
		result = DirAccess.make_dir_recursive_absolute(path)
	else:
		result = DirAccess.make_dir_absolute(path)

	if result != OK:
		logger().critical("Make directory failed", "data", {"path": path, "error_no": result})

		return false

	return true

# remove directory or file
func rm(path: String):
	if exists(path):
		var result = DirAccess.remove_absolute(path)

		if result != OK:
			logger().critical("Removing directory failed", "data", {"path": path, "error_no": result})

			return false

		return true
	else:
		return false

# rename directory or file to another name
func mv(from_path: String, to_path: String):
	if exists(from_path):
		var result = DirAccess.rename_absolute(from_path, to_path)

		if result != OK:
			logger().critical("Rename operation failed", "data", {"from": from_path, "to": to_path, "error_no": result})

			return false

		return true
	else:
		return false

# copy directory or file to another location
func cp(from_path: String, to_path: String):
	if exists(from_path) and not isdir(from_path):
		var result = DirAccess.copy_absolute(from_path, to_path)

		if result != OK:
			logger().critical("Copy operation failed", "path", {"from": from_path, "to": to_path, "error_no": result})

			return false

		return true
	else:
		return false
