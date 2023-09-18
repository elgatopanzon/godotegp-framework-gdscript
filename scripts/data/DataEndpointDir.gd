######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointDir
# @created     : Wednesday Sep 13, 2023 17:38:22 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : DataEndpoint class handling directories
######################################################################

class_name DataEndpointDir
extends DataEndpoint

var _dir_path: String
var _dir_object: DirAccess
var _dir_open_error: ResultError

# object constructor
func _init(dir_path: String):
	_dir_path = dir_path

	_dir_object = DirAccess.open(_dir_path)

	if not _dir_object:
		_dir_open_error = ResultError.new(self, DirAccess.get_open_error(), {"path": _dir_path})

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataEndpointDir"

func to_dict():
	return {
		"dir_path": _dir_path,
	}

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

# check if valid
func is_valid():
	return _dir_open_error == null # if there's no open error, it's valid

# walk a directory and return a nested dict
# BUGGED CAUSES CRASHES
func walk(path: String = _dir_path, recursive: int = true, directory_contents = []):
	# if the dir object is null, accessing the directory failed
	print("walking dir: %s" % path)

	_dir_object = DirAccess.open(path)

	if not _dir_object:
		Services.Events.error(self, "failed_to_open_directory", {"path": _dir_path, "resource": _data_resource})

		return null

	_dir_object.list_dir_begin()

	var file_name = _dir_object.get_next()
	while file_name != "":
		if _dir_object.current_is_dir():
			# fetch contents
			print("dir: %s" % file_name)
			var directory = null
			if recursive:
				directory = walk(path+"/"+file_name, recursive, directory_contents)
			else:
				directory = file_name

			directory_contents.append(directory)
		else:
			# append to contents
			print("file: %s" % file_name)
			directory_contents.append(file_name)

		file_name = _dir_object.get_next()

	return directory_contents 

# list contents of directory
func list():
	# returns the open error if one was generated
	if _dir_open_error:
		var error = ResultError.new(self, "list_directory_error", {"path": _dir_path})
		error.add_error(_dir_open_error)
		return Result.new(false, error)
	else:
		return Result.new(_dir_object.get_directories() + _dir_object.get_files())

# check file or dir exists
func exists():
	if _dir_open_error:
		var error = ResultError.new(self, "directory_exists_error", {"path": _dir_path})
		error.add_error(_dir_open_error)
		return Result.new(false, error)

	# return result object with value
	return Result.new(_dir_object.file_exists(_dir_path) or _dir_object.dir_exists(_dir_path))

func isdir():
	if _dir_open_error:
		var error = ResultError.new(self, "is_directory_error", {"path": _dir_path})
		error.add_error(_dir_open_error)
		return Result.new(false, error)

	return Result.new(_dir_object.dir_exists(_dir_path))
