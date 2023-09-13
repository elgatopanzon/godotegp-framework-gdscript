######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointFiletypeINI
# @created     : Wednesday Sep 13, 2023 00:26:22 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : 
######################################################################

class_name DataEndpointFiletypeINI
extends DataEndpointFiletype

# object constructor
func _init():
	SUPPORTED_EXTENSIONS = ["ini", "cfg"] 
	pass

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataEndpointFiletypeINI"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass
