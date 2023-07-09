extends Node

var project_path : String = ""

var settings : Dictionary = {}

# gets all settings of .json file and stores the in local dictionary
func load_project(path : String):
	project_path = path
	var f = FileAccess.open(path, FileAccess.READ)
	var data = f.get_as_text()
	settings = JSON.parse_string(data)
	f.close()

# Saves changed local settings into the .json file
func save():
	var f = FileAccess.open(project_path, FileAccess.WRITE)
	f.store_string(str(settings))
	f.close()


#func set_value(tag : String, args):
#	pass
#
#func get_value(tag : String):
#	pass
