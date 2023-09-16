######################################################################
# @author      : ElGatoPanzon
# @class       : test_Result
# @created     : Friday Sep 15, 2023 19:10:50 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Tests for Result class
######################################################################

extends GutTest

class TestResult:
	extends GutTest

	# asserts for this class
	func test_assert_success_property_true_when_no_errors():
		var obj = Result.new(true)
		assert_eq(obj.SUCCESS, true, "There's no errors so SUCCESS is true")

	func test_assert_failed_property_false_when_no_errors():
		var obj = Result.new(true)
		assert_eq(obj.FAILED, false, "There's no errors so FAILED is false")

	func test_assert_return_value_is_set_and_available():
		var obj = Result.new("123")
		assert_eq(obj.value, "123", "Return value property should match constructor")

	func test_assert_success_property_false_when_error():
		var double_ResultError = double(ResultError).new(self, "test_error")
		var obj = Result.new(true, double_ResultError)

		assert_eq(obj.SUCCESS, false, "There's errors so SUCCESS is false")
