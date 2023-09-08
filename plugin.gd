@tool
extends EditorPlugin

const PLUGIN_DIR = "res://addons/godotegp-framework"
const SERVICEMANAGER_AUTOLOAD_NAME = "Services"

func _enter_tree():
	# add framework autoloads
	add_autoload_singleton(SERVICEMANAGER_AUTOLOAD_NAME, PLUGIN_DIR+"/scripts/ServiceManager.gd")


func _exit_tree():
	# remove framework autoloads
	remove_autoload_singleton(SERVICEMANAGER_AUTOLOAD_NAME)
