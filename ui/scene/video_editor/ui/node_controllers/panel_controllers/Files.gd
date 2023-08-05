extends Control

var file_explorer_open : bool = false

@onready var grid = $Content/ScrollContainer/GridContainer

var queued_imports : Dictionary = {}

# Gets called once at start of program
func _ready():
	# Connect drag-n-drop signal to local function
	get_window().connect("files_dropped", Callable(self, "files_dropped"))
	# Connect file selection to local function
	var exp = INSTBUS.popup_manager.get_node_or_null("Popups/FileExplorer/Panel/MarginContainer/Content/AcceptBtns/Button")
	if exp == null: print("ERROR : Couldn't create a connection to the FileExplorer popup..."); return
	exp.connect("pressed", Callable(self, "selected"))
	# Update UI at restart
	grid.update_preview()


# gets called, when files droppped
func files_dropped(packed_files : PackedStringArray):
	# Unpack and import file for each dropped file
	for path in Array(packed_files):
		var valid = FFMPEG.validate_import(path)
		
		if not valid: print("tried to import invalid file type : path" + str(path)); continue # skip to next file, if not valid
		
		import(path)


func _on_add_file_btn_pressed():
	INSTBUS.popup_manager.show_popup("FileExplorer")

func selected():
	# Constantly checks, if the file explorer selected a file to import
	var explorer = INSTBUS.popup_manager.find_popup("FileExplorer")
	
	# print(explorer.name)
	
	var paths = explorer.get_selected_file_btn()
	
	if paths.is_empty(): return
	
	for fbtn in paths:
		import(fbtn.path)

# Runs every frame
func _process(_delta):
	# Updates every thread and checks, if done
	for q in queued_imports.keys():
		var thread : Thread = queued_imports.get(q)
		if not thread.is_alive() and thread.is_started():
			print("Starting stop process oof thread importing...")
			var thread_data = thread.wait_to_finish()
			print("Thread merged with main thread")
			var target_path = thread_data[0]
			print("new adress is : " + target_path)
			if not PROJECTINFO.settings.has("resources"):
				PROJECTINFO.settings["resources"] = []
			
			PROJECTINFO.settings["resources"].append(target_path)
			PROJECTINFO.save()
			
			print("Saved traget path in Save file")
			# Create UI
			grid.update_preview()
			
			print("Created UI component")
			# Clear bottom bar
			INSTBUS.bottom_bar.clear_info(thread_data[1])
			
			# Remove thread from list
			queued_imports.erase(q)
	
	if queued_imports.is_empty():
		INSTBUS.bottom_bar.clear_ps()

func import(path : String):
	var id = PROJECTINFO.settings["resources"].size()
	INSTBUS.bottom_bar.set_ps("Importing : ", " ...")
	INSTBUS.bottom_bar.add_info("'" + path + "'", id)
	# TODO : Definately improve loading speed
	# FIXME : "Bad adress index" error when finished loading resource on seperate thread, error while ending thread
	
	# Add progress update by : 
	# 1. Moving importing to seperate thread
	# 2. get loading percentage by reading, how many files are already in the .frames folder compared to max
	
	# TODO : manage que using GDExtension addon and TaskList Class
	var thread = Thread.new()
	thread.start(Callable(self, "convert_and_move").bind(path, id))
	queued_imports[path] = thread

func convert_and_move(path : String, id : int):
	var target_path = FFMPEG.import(path)
	var tag = path.rsplit("/", true, 1)[1]
	print("File : < " + tag + " > stored in local project folder...")
	return [target_path, id]
