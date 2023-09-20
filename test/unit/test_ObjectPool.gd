######################################################################
# @author      : ElGatoPanzon
# @class       : test_ObjectPool
# @created     : Monday Sep 18, 2023 15:08:10 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Tests for ObjectPool
######################################################################

extends GutTest

class TestObjectPool:
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
	func test_assert_object_instantiate_builtin_from_string():
		var pool = autofree(ObjectPool.new("Node"))
		var instance = autofree(pool.instantiate())

		assert_is(instance, Node, "Is instance of Node builtin!")

	func test_assert_object_instantiate_custom_from_string():
		var pool = autofree(ObjectPool.new("Result", "RefCounted", Result.new(false).get_script().get_path()))
		var instance = autofree(pool.instantiate([false]))

		assert_is(instance, Result, "Is instance of Result custom class!")
