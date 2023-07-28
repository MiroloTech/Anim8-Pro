extends Node

var SUPPORTED_FILE_TYPES = [
	"MP4",
	"AVI",
	"MPG",
	"MOV",
	"OGV",
	"MKV",
	
	"PNG",
	"JPG",
	
	# "TXT"
]

var local_project_path = "res://project_files/files/"

func test():
	var out = []
	OS.execute("ffmpeg", ["-version"], out)
	for l in out: print(l)
	
	# conv("D:/DATA/Games/Anim8-Pro/test/GaryBurp.ogv", "JPG")

# Converts file to specific type using ffmpeg
func conv(global_path : String, end_type : String):
	if not SUPPORTED_FILE_TYPES.has(end_type): push_error("Tried to convert file <" + global_path + "> to unsupported file type <" + end_type + "> ..."); return true
	var out = []
	
	# Split path between path and file name
	var splitted = global_path.rsplit("/", true, 1)
	var path = splitted[0]
	var file = splitted[1]
	var file_name = file.split(".")[0]
	# var file_type = file.split(".")[1]
	
	# Navigate Shell to path
	# if path.begins_with("D:"):
		# OS.execute("D:", [], out)
	# OS.execute("cd", [path], out)
	
	# Switch between file types
	if end_type == "PNG" or end_type == "JPG": # HDT : add .webp
		# convert to Image sequence
		var end_path = '"' + path + "/" + file_name + ".frames/out-%03d." + end_type.to_lower() + '"'
		DirAccess.make_dir_absolute(path + "/" + file_name + ".frames")
		OS.execute("ffmpeg", ["-i", '"' + global_path + '"', end_path], out)
	
	else:
		# Convert to video
		var end_path = path + "/" + file_name + "." + end_type.to_lower()
		OS.execute("ffmpeg", ["-i", global_path, end_path], out)
	
	for l in out: print(l)
	
	return false

func change_speed(local_path : String, new_fps : int) -> String: # Broken
	var global_path : String = ProjectSettings.globalize_path(local_path)
	var splitted = global_path.rsplit("/", true, 1)
	var path = splitted[0]
	var file = splitted[1]
	var file_name = file.split(".")[0]
	var file_type = file.split(".")[1]
	
	var end_path = path + "/" + file_name + "-" + str(new_fps) + "fps" + "." + file_type
	print(end_path)
	
	var out = []
	OS.execute("ffmpeg", ["-i " + global_path, "-crf 10", "filter:v " + "tblend" + " -r " + str(new_fps), end_path], out)
	for l in out: print(l)
	
	return end_path

# Validates, if an import of the file is valid
func validate_import(path : String) -> bool:
	var file_type = (path.rsplit(".", true, 1)[1]).to_upper()
	return SUPPORTED_FILE_TYPES.has(file_type)

# imports files to local directory
func import(path : String):
	"""
	# read external file
	var old_file = FileAccess.open(path, FileAccess.READ)
	var data = old_file.get_as_text()
	old_file.close()
	
	# create new internal file
	var file_name = path.rsplit("\\", true, 1)[1]
	var new_file = FileAccess.open(local_project_path + file_name, FileAccess.WRITE)
	new_file.store_string(data)
	new_file.close()
	"""
	
	# Use FFMPEG conversion with - i and -o to move files and simultainioulsy convert to image sequence
	
	# print("imported new file at : " + local_project_path + file_name)

func _ready():
	test()
