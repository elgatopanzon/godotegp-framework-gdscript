######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointParserJSON
# @created     : Wednesday Sep 13, 2023 15:22:41 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Parse text to JSON
######################################################################

class_name DataEndpointParserJSON
extends DataEndpointParser

# object constructor
func _init():
	SUPPORTED_CONTENT_TYPES = ["json"]

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataEndpointParserJSON"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

func parse(content: String, content_type: String):
	var content_parsed = null

	if content_type == "json":
		var json = JSON.new()
		var parsed_json_result = json.parse(content)

		if parsed_json_result == OK:
			content_parsed = json.data
		else:
			logger().critical("Parsing JSON failed", "data", {"content": content, "error": json.get_error_message()})

			return null

	# return parsed content
	return content_parsed

func unparse(content, content_type: String):
	var unparsed_content = ""

	if content_type == "json":
		var stringified_json = JSON.stringify(content)

		if stringified_json:
			unparsed_content = stringified_json
		else:
			logger().critical("Stringify to JSON failed", "content", content)

			return null

	return unparsed_content
