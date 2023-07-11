extends Control

# Gets called once at start of program
func _ready():
	# Connect drag-n-drop signal to local function
	get_window().connect("files_dropped", Callable(self, "files_dropped"))

# TODO
func import():
	pass

# gets called, when files droppped
func files_dropped(packed_files : PackedStringArray):
	# Unpack and import file for each dropped file
	for path in Array(packed_files):
		var valid = FFMPEG.validate_import(path)
		
		if not valid: print("tried to import invalid file type : path" + str(path)); continue # skip to next file, if not valid
		
		FFMPEG.import(path)
