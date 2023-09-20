######################################################################
# @author      : ElGatoPanzon
# @class       : test_EventFilter
# @created     : Monday Sep 18, 2023 16:09:16 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Tests for EventFilter objects
######################################################################

extends GutTest

class TestEventFilter:
	extends GutTest

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
	func test_assert_event_filter_group():
		var filter = autofree(EventFilterGroup.new("test_group"))
		var node = autofree(Node.new())
		node.add_to_group("test_group")

		var event = autofree(EventBasic.new(node, {}))

		assert_true(filter.match(event), "Should be in the group")

	func test_assert_event_filter_type():
		var filter = autofree(EventFilterType.new(EventBasic))
		var node = autofree(Node.new())

		var event = autofree(EventBasic.new(node, {}))

		assert_true(filter.match(event), "Should be matching type")

	func test_assert_event_filter_nodeid():
		var filter = autofree(EventFilterNodeID.new("test_id"))
		var node = autofree(Node.new())

		node.set_meta("id", "test_id")

		var event = autofree(EventBasic.new(node, {}))

		assert_true(filter.match(event), "Should be matching type")
