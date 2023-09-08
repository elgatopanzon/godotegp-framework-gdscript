######################################################################
# @author      : ElGatoPanzon
# @class       : plugin
# @created     : Friday Sep 08, 2023 17:23:50 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Main plugin file for godotegp-framework
######################################################################

@tool
extends EditorPlugin

const PLUGIN_DIR = "res://addons/godotegp-framework"
const SERVICEMANAGER_AUTOLOAD_NAME = "Services"

# scene lifecycle methods
# called when node enters the tree
func _enter_tree():
	# add framework autoloads
	add_autoload_singleton(SERVICEMANAGER_AUTOLOAD_NAME, PLUGIN_DIR+"/scripts/ServiceManager.gd")

# called when node exits the tree
func _exit_tree():
	# remove framework autoloads
	remove_autoload_singleton(SERVICEMANAGER_AUTOLOAD_NAME)
