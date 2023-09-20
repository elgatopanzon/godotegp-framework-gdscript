######################################################################
# @author      : ElGatoPanzon
# @class       : test_DataEndpointFiletypeCSV
# @created     : Monday Sep 18, 2023 18:02:38 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : Integration test of DataEndpointFiletypeCSV
######################################################################

extends GutTest

# class TestDataEndpointFiletypeCSV:
# 	extends GutTest
#
# 	var instance = DataEndpointFiletypeCSV
# 	var test_file = "user://DataEndpointFiletypeCSV-test.csv"
# 	var data_resource: DataResource
#
# 	# class hooks for setup and teardown
# 	func before_all():
# 		pass
# 	func before_each():
# 		data_resource = autofree(DataResourceArray.new(DataResource))
#
# 		data_resource._data = [
# 			DataResource.new()
# 		]
# 	func after_each():
# 		pass
# 	func after_all():
# 		pass
#
# 	# asserts for this class
# 	func test_assert_writing_data_resource_as_csv():
#
# 		var endpoint = autofree(instance.new())
# 		endpoint.set_file_object(autofree(FileAccess.open(test_file, FileAccess.WRITE)))
# 		var r = endpoint.save_to_file(data_resource)
#
# 		assert_true(r.SUCCESS, "Saving should be successful")
#
# 	func test_assert_reading_csv_content_into_array():
# 		var endpoint = autofree(instance.new())
# 		endpoint.set_file_object(autofree(FileAccess.open(test_file, FileAccess.READ)))
#
# 		var r = endpoint.load_from_file()
#
# 		DirAccess.remove_absolute(test_file)
#
# 		assert_true(r.SUCCESS, "Loading should be successful")
#
# 		assert_eq(r.value, data_resource._data, "Loaded data dict should be identical to the one saved")
