######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointWeb
# @created     : Wednesday Sep 13, 2023 15:10:22 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : DataEndpoint to load content from the web
######################################################################

class_name DataEndpointWeb
extends DataEndpoint

var CONTENT_PARSERS = [
	DataEndpointParserJSON.new(),
]

var _url: String
var _url_path: String
var _port: int
var _content_type: String
var _request_method: String

var _http

# object constructor
func _init(url: String, port: int, url_path: String, content_type: String = "", request_method: String = "GET"):
	_url = url
	_url_path = url_path
	_port = port
	_content_type = content_type
	_request_method = request_method

	# init a HTTP client object
	_http = HTTPClient.new()

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataEndpointWeb"

func to_dict():
	return {
		"url": _url,
		"content_type": _content_type,
		"request_method": _request_method
	}

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
#	pass

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

func get_content_parser():
	for imp in CONTENT_PARSERS:
		if imp.is_supported_content_type(_content_type):
			return imp

	return false

func load_data():
	return await process_web_operation(0)

func save_data():
	return await process_web_operation(1)

func process_web_operation(type: int):
	var content_parser = get_content_parser()

	# content type not implemented
	if not content_parser:
		logger().critical("Unsupported content type", "type", _content_type)
		logger().critical("...", "url", _url)
		logger().critical("...", "resource", _data_resource)

		return null	

	# make sure we can connect to the host
	var connect_error = verify_connection()
	if not connect_error == OK:
		logger().critical("Unable to connect to URL", "url", _url)
		logger().critical("...", "error", connect_error)

		return null

	await init_connect()

	if _http.get_status() != HTTPClient.STATUS_CONNECTED:
		logger().critical("Connection to URL failed", "url", _url)
		logger().critical("...", "status", _http.get_status())

		return null

	# make the request if the connection succeeded
	var headers = [
		"User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*"
	]

	var request_body = ""

	var method = HTTPClient.METHOD_GET
	if _request_method == "POST":
		method = HTTPClient.METHOD_POST

		request_body = content_parser.unparse(_data_resource.to_dict(), _content_type)
	if _request_method == "PUT":
		method = HTTPClient.METHOD_PUT

	var request_error = _http.request(method, _url_path, headers, request_body)

	await check_request()

	var request_success = (_http.get_status() == HTTPClient.STATUS_BODY or _http.get_status() == HTTPClient.STATUS_CONNECTED)

	if not request_success:
		logger().critical("HTTP request failed", "url", _url)
		logger().critical("...", "path", _url_path)
		logger().critical("...", "status", _http.get_status())

		return null

	if not _http.has_response() and type == 0: # error if we're trying to load data
		logger().critical("HTTP request has no response", "url", _url)
		logger().critical("...", "path", _url_path)

		return null

	# get the data from the response
	var rb = PackedByteArray() # Array that will hold the data.

	while _http.get_status() == HTTPClient.STATUS_BODY:
		_http.poll()
		var chunk = _http.read_response_body_chunk()
		if chunk.size() == 0:
			if not OS.has_feature("web"):
				OS.delay_usec(1000)
			else:
				await Engine.get_main_loop().idle_frame
		else:
			rb = rb + chunk

	var text_response = rb.get_string_from_ascii()

	logger().debug("HTTP request response body", "body", text_response)

	# saving or loading, HTTP response matters to verify if the save was successful
	var parsed_content = content_parser.parse(text_response, _content_type)

	if parsed_content == null:
		logger().critical("Failed to parse HTTP response data", "url", _url)
		logger().critical("...", "path", _url_path)
		logger().critical("...", "body", text_response)

		return null
	
	return parsed_content


func verify_connection():
	return _http.connect_to_host(_url, _port)

func init_connect():
	while _http.get_status() == HTTPClient.STATUS_CONNECTING or _http.get_status() == HTTPClient.STATUS_RESOLVING:
		_http.poll()
		if not OS.has_feature("web"):
			OS.delay_msec(500)
		else:
			await Engine.get_main_loop().idle_frame

func check_request():
	while _http.get_status() == HTTPClient.STATUS_REQUESTING:
		_http.poll()
		if not OS.has_feature("web"):
			OS.delay_msec(500)
		else:
			await Engine.get_main_loop().idle_frame
