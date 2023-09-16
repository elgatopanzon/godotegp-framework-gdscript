######################################################################
# @author      : ElGatoPanzon
# @class       : test_ResultError
# @created     : Friday Sep 15, 2023 19:12:00 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Tests for ResultError class
######################################################################

extends GutTest

class TestResultError:
	extends GutTest

	var error

	# class hooks for setup and teardown
	func before_all():
		error = ResultError.new(self, "test_error")
		pass
	func before_each():
		pass
	func after_each():
		pass
	func after_all():
		pass

	# asserts for this class
	func test_error_type_correctly_set():
		assert_eq(error.get_type(), "test_error", "Error type correctly set!")

	func test_adding_child_error():
		var child_error = ResultError.new(self, "child_error")
		error.add_error(child_error)
		assert_eq(error.get_errors()[0], child_error, "Error matches child error!")
