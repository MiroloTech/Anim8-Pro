extends Node

# TODO : Test video conversion with new ffmpeg implementation
# TODO : Add touch screen support
# TODO : Improve Laptop support

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
var ffmpeg_path = "C:/Users/liams/OneDrive/Desktop/App/ffmpeg-6.0-full_build/bin/" # TODO : Save this path externally

var is_valid : bool = false

# Executes a function in the command prompt
func cmd(command : Array[String]):
	var out = []
	var c = command.duplicate()
	c.push_front("/C")
	var err = OS.execute("CMD.exe", c, out, false, false)
	return {"out" : out, "err" : err}

func ffmpeg(command : String):
	return cmd([ffmpeg_path + "ffmpeg " + command])

func test():
	print("Tests running...")
	
	var test = ffmpeg("-version")
	var err = test.err
	var out_arr = test.out
	
	print(test)
	
	var out = ""
	for l in out_arr.size() - 1: out += l + "\n"
	out += out_arr[out_arr.size()-1]
	
	# print("FFMPEG Error ?= " + str(err))
	
	# conv("D:/DATA/Games/Anim8-Pro/test/GaryBurp.ogv", "JPG")
	# conv("C:/Users/liams/OneDrive/Dokumente/Anim8-Pro/Anim8-Pro/test/GaryBurp.ogv", "JPG")
	
	if err == -1 or out == "": # TODO : add more suffisticated error handeling
		INSTBUS.popup_manager.queue_popup("ffmpegErrorPopup")
	else:
		is_valid = true

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
		out = ffmpeg('-i "' + global_path + '" ' + end_path).out
	
	else:
		# Convert to video
		var end_path = path + "/" + file_name + "." + end_type.to_lower()
		out = ffmpeg("-i " + global_path + " " + end_path).out
	
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
	
	var out = ffmpeg("-i " + global_path + " -crf 10 filter:v tblend -r " + str(new_fps) + " " + end_path).out
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
