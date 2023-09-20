######################################################################
# @author      : ElGatoPanzon
# @class       : test_RandomNumberGeneratorExtended
# @created     : Monday Sep 18, 2023 15:23:20 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Tests for RandomNumberGeneratorExtended
######################################################################

extends GutTest

class TestRandomNumberGeneratorExtended:
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
	func test_assert_seed_restoring_state():
		# create instance with seed but no state
		var random = RandomNumberGeneratorExtended.new(123)
		# save startup state
		var state = random.state

		var randf = random.randf()

		# create 2nd instance with another saved state
		var random2 = RandomNumberGeneratorExtended.new(123, state)
		var randf2 = random2.randf()

		assert_eq(randf, randf2, "Repeated state and seed should produce the same number")
