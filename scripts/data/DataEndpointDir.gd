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

# object constructor
func _init(dir_path: String):
	_dir_path = dir_path

	_dir_object = DirAccess.open(_dir_path)

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
	return _dir_object

# walk a directory and return a nested dict
# BUGGED CAUSES CRASHES
func walk(path: String = _dir_path, recursive: int = true, directory_contents = []):
	# if the dir object is null, accessing the directory failed
	print("walking dir: %s" % path)

	_dir_object = DirAccess.open(path)

	if not _dir_object:
		logger().critical("Could not open directory", "path", _dir_path)

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
	return _dir_object.get_directories() + _dir_object.get_files()

# check file or dir exists
func exists():
	if _dir_object.file_exists(_dir_path):
		return true

	if _dir_object.dir_exists(_dir_path):
		return true

	return false

func isdir():
	if _dir_object.dir_exists(_dir_path):
		return true

	return false
