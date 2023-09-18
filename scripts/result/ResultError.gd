######################################################################
# @author      : ElGatoPanzon
# @class       : ResultError
# @created     : Friday Sep 15, 2023 19:00:06 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Result object's accompanying Error object
######################################################################

class_name ResultError
extends RefCounted

const ERROR_STRINGS = {
	1: "generic_error",
	2: "unavailable",
	3: "unconfigured",
	4: "unauthorised",
	5: "parameter_range_error",
	6: "out_of_memory",
	7: "file_not_found",
	8: "file_bad_drive",
	9: "file_bad_path",
	10: "file_no_permission",
	11: "file_in_use",
	12: "file_cant_open",
	13: "file_cant_write",
	14: "file_cant_read",
	15: "file_unrecognised",
	16: "file_corrupt",
	17: "file_missing_dependencies",
	18: "file_eof",
	19: "cant_open",
	20: "cant_create",
	21: "query_failed",
	22: "in_use",
	23: "locked",
	24: "timeout",
	25: "cant_connect",
	26: "cant_resolve",
	27: "connection_error",
	28: "cant_acquire_resource",
	29: "cant_fork",
	30: "invalid_data",
	31: "invalid_parameter",
	32: "already_exists",
	33: "does_not_exist",
	34: "database_cant_read",
	35: "database_cant_write",
	36: "compilation_failed",
	37: "method_not_found",
	38: "link_failed",
	39: "script_failed",
	40: "cyclic_link",
	41: "invalid_declaration",
	42: "duplicate_symbol",
	43: "parse_error",
	44: "busy",
	45: "skip",
	46: "help",
	47: "bug",
	48: "printer_on_fire",
	400: "http_bad_request",
	401: "http_unauthorised",
	402: "http_payment_required",
	403: "http_forbidden",
	404: "http_not_found",
	405: "http_method_not_allowed",
	406: "http_not_acceptable",
	407: "http_proxy_authentication_required",
	408: "http_request_timeout",
	409: "http_conflict",
	410: "http_gone",
	411: "http_length_required",
	412: "http_precondition_failed",
	413: "http_request_entity_too_large",
	414: "http_request_uri_too_short",
	415: "http_unsupported_media_type",
	416: "http_requested_range_not_satisfiable",
	417: "http_expectation_failed",
	418: "http_im_a_teapot",
	421: "http_misdirected_request",
	422: "http_unprocessable_entity",
	423: "http_locked",
	424: "http_failed_dependency",
	426: "http_upgrade_required",
	428: "http_precondition_required",
	429: "http_too_many_requests",
	431: "http_request_header_fields_too_large",
	451: "http_unavailable_for_legal_reasons",
	500: "http_internal_server_error",
	501: "http_not_implemented",
	502: "http_bad_gateway",
	503: "http_service_unavailable",
	504: "http_gateway_timeout",
	505: "http_version_not_supported",
	506: "http_variant_also_negotiates",
	507: "http_insufficient_storage",
	508: "http_loop_detected",
	510: "http_not_extended",
	511: "http_network_authentication_required",
}


var _error_owner: Object
var _error_type
var _error_message
var _error_data
var _child_errors: Array[ResultError]

# object constructor
func _init(owner: Object, type, data = null, message: String = ""):
	_error_owner = owner
	_error_data = data

	set_type(type)

	_error_message = message if message != "" else _error_type

func init():
	return self

func add_error(error: ResultError):
	_child_errors.append(error)
func get_errors():
	return _child_errors

func get_type():
	return _error_type
func get_message():
	return _error_message
func get_data():
	return _error_data
func get_error_count():
	return _child_errors.size()

func set_type(type):
	_error_type = type

	if typeof(type) != TYPE_STRING:
		set_error_type_from_no(type)

func set_message(message: String):
	_error_message = message

# friendly name when printing object
func _to_string():
	return "ResultError"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

func to_dict():
	return {
		"owner": _error_owner,
		"type": _error_type,
		"message": _error_message,
		"data": _error_data,
		"child_errors": _child_errors,
	}

# translate an error number into a type string
func set_error_type_from_no(error_no):
	var error_string = ERROR_STRINGS.get(error_no, "unknown_error_code_%s" % error_no)

	set_type(error_string)
