######################################################################
# @author      : ElGatoPanzon
# @class       : test_LoggerTextBlock
# @created     : Monday Sep 18, 2023 13:37:59 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Tests for LoggerTextBlock
######################################################################

extends GutTest

class TestInit:
	extends GutTest

	var instance = LoggerTextBlock

	# class hooks for setup and teardown
	func before_all():
		pass
	func before_each():
		pass
	func after_each():
		pass
	func after_all():
		pass

	# asserts for this class
	func test_assert_init_returns_self():
		var obj = autofree(instance.new())
		var init_res = obj.init("")
		assert_eq(obj, init_res, "Should match and return self")

	var p_get_next_line = ParameterFactory.named_parameters(["line_length", "text", "lines"], 
		[
			[0, "this line is longer than 10 characters",
			["", "", "", ""]
			],
			[8, "this line is longer than 10 characters",
			["this", "line is", "longer", "than 10", "characters"]
			],
			[9, "this line is longer than 10 characters",
			["this line", "is longer", "than 10", "characters"]
			],
			[10, "this line is longer than 10 characters",
			["this line", "is longer", "than 10", "characters"]
			],
			[11, "this line is longer than 10 characters",
			["this line", "is longer", "than 10", "characters"]
			],
			[10, "short",
			["short", "", "", ""]
			],
		]
		)

	func test_assert_line_length_get_next_line(p=use_parameters(p_get_next_line)):
		var obj = autofree(instance.new())
		var line_length = p.line_length
		var init_res = obj.init("line", p.line_length)

		obj.set_value(p.text)

		var actual_lines = []

		# assert that lines equal params
		var c = 0
		for line in p.lines:
			actual_lines.append(obj.get_next_line())

			assert_eq(actual_lines[c], line, "Should match %s" % line)

			c += 1
