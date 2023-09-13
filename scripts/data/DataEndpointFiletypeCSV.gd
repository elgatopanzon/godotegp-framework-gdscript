######################################################################
# @author      : ElGatoPanzon
# @class       : DataEndpointFiletypeCSV
# @created     : Wednesday Sep 13, 2023 00:25:19 CST
# @copyright   : Copyright (c) ElGatoPanzon 2023
#
# @description : 
######################################################################

class_name DataEndpointFiletypeCSV
extends DataEndpointFiletype

# object constructor
func _init():
	SUPPORTED_EXTENSIONS = ["csv"] 
	pass

func init():
	return self

# friendly name when printing object
func _to_string():
	return "DataEndpointFiletypeCSV"

# integration with Services.Log
func logger():
	return Services.Log.get(self.to_string())

# used by ObjectPool
func prepare():
	pass
func reinit():
	pass

func load_from_file():
	var parsed_csv = []
	var parsed_csv_headings = []

	var line_counter = 0
	while not _file_object.eof_reached():
		var csv_line = _file_object.get_csv_line()

		print(csv_line)

		var csv_line_dict = {}

		var csv_item_counter = 0
		for csv_item in len(csv_line):
			if not csv_line[csv_item]:
				break

			# headings line
			if line_counter == 0:
				parsed_csv_headings.append(csv_line[csv_item])
				
			# data line
			else:
				csv_line_dict[parsed_csv_headings[csv_item_counter]] = csv_line[csv_item]

			csv_item_counter += 1

		# after headings, start recording items
		if line_counter > 0 and csv_item_counter > 0:
			parsed_csv.append(csv_line_dict)

		line_counter += 1

	
	print(parsed_csv)
	return parsed_csv


func save_to_file():
	pass
