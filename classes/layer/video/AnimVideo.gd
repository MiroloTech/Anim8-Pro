extends AnimLayer
class_name AnimVideo

var local_path : String = ""
var fps : int = 30 # TODO : Set at init
var original_fps : int = 30

var original_frames : Array[Image] = []
var frames : Array[Image] = []

func get_frame(time : float):
	var t = floor(time * fps)
	return frames[t] if t == clampi(t, 0, frames.size()) else null 

func convert_to_render(local_path : String):
	var global_path = ProjectSettings.globalize_path(local_path)
	self.local_path = local_path
	
	var err = FFMPEG.conv(global_path, "PNG") # TODO : Add quick_import option for .jpg conversion
	if err: push_error("Opening Video File in 'AnimVideo' failed..."); return
	
	
	var splitted = local_path.rsplit("/", true, 1)
	var path = splitted[0]
	var file = splitted[1]
	var file_name = file.split(".")[0]
	var file_type = file.split(".")[1]
	
	var img_dir_path = path + "/" + file_name + ".frames"
	var img_folder = DirAccess.open(img_dir_path)
	
	frames.clear()
	
	img_folder.list_dir_begin()
	var fn = img_folder.get_next()
	
	while fn != "":
		if not fn.ends_with(".import"):
			var img = Image.new()
			img.load(img_dir_path + "/" + fn)
			frames.append(img)
		
		fn = img_folder.get_next()

func sequence_from_file(path : String):
	pass

func ai_resize(new_resolution : Vector2i):
	pass

# Imports Video into project
func import(pos : float, local_path : String, fps : int):
	# Init Variables
	self.start_pos = pos
	self.fps = fps
	
	# Convert to usable type ( Image sequence )
	convert_to_render(local_path)
	
	# Calculate clip length
	self.length = float(frames.size()) / float(fps)
	
	is_ready = true

func new_from_frames(pos : float, frames : Array[Image], fps : int):
	# Init Variables
	self.start_pos = pos
	self.fps = fps
	
	# Convert to usable type ( Image sequence )
	self.frames = frames
	
	# Calculate clip length
	self.length = float(frames.size()) / float(fps)
	
	is_ready = true

func warn_edit():
	original_frames = frames.duplicate()
	original_fps = fps
