extends Control

@onready var button_list = $Panel/MarginContainer/Content/Files/SmoothScrollContainer/VBoxContainer
@onready var title_dir_edit = $Panel/MarginContainer/Content/Controls/FilePath
@onready var search_bar = $Panel/MarginContainer/Content/Controls/SearchBar/MarginContainer/Content/LineEdit

var current_path : String = ""
var file_buttons : Array[FileBtn] = []

const DOUBLECLICK_TIME = 0.35

class FileBtn:
	var id : int = 0
	var tag : String = "..."
	var type : String = ""
	var icon : Image = null
	var selected_time : float = 0.0
	var clicks : int = 0
	
	var ui : Control = null
	
	func _init(tag : String, type : String = "_", id : int = -1):
		self.id = id
		self.tag = tag
		self.type = type if GLOBAL.FILE_TYPE.has(type) else "null"
		self.icon = Image.load_from_file(GLOBAL.FILE_TYPE[self.type][0])
		
		create_ui()
		
		ui.connect("pressed", Callable(self, "pressed"))
	
	func create_ui():
		var btn = Button.new()
		btn.text = self.tag
		btn.focus_mode = Control.FOCUS_NONE
		btn.toggle_mode = true
		
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		btn.icon = ImageTexture.new()
		btn.icon.image = icon
		btn.expand_icon = true
		btn.icon_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		var color = GLOBAL.FILE_TYPE[self.type][1]
		btn.set("theme_override_colors/font_color", Color("757575"))
		btn.set("theme_override_colors/icon_normal_color", color) # TODO, set to assigned color
		btn.set("font_sizes/font_size", 14)
		
		ui = btn
	
	func pressed():
		clicks += 1



# Test function, starts once at start of program
func _ready():
	current_path = "res://ui/scene/video_editor/test/"
	load_items_from_path(current_path)

# Runs every frame, is used to udate things constantly
func _process(delta):
	select_sinlg_ctrl()
	manage_file_btn_times(delta)
	
	# Manage double-clicked
	var double_clicked = get_double_clicked()
	if double_clicked != null:
		if double_clicked.type == "_":
			current_path += double_clicked.tag + "/"
			load_items_from_path(current_path)


func AAATest(a : float, b : String = "pbaowd"):
	print("tested >> a : " + str(a) + ", b : " + b)

# loads all button items based on a given path
func load_items_from_path(path : String) -> void:
	clear_btns()
	
	# if not is_path_valid(path): print("ERROR : Tried to open an invalid path in file explorer..."); return
	
	var dir = DirAccess.open(path) # TODO : fix errer when going back from  /ui/  folder
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var splitted_name = file_name.rsplit(".", true, 1)
			var type = "_" if dir.current_is_dir() else (splitted_name[1] if splitted_name.size() > 1 else "null")
			var file = FileBtn.new(file_name, type)
			
			button_list.add_child(file.ui)
			file_buttons.append(file)
			
			file_name = dir.get_next()
	else:
		print("ERROR : A problem occurred while trying to access a path in file explorer...")
	
	# Set title path
	title_dir_edit.text = path


# sets path back one step and reloads the visual explorer
func back() -> void:
	print(current_path)
	var last_part = "/" + current_path.rsplit("/", false, 1)[1]
	current_path = current_path.replace(last_part, "")
	load_items_from_path(current_path)

# clear all file buttons in explorer
func clear_btns() -> void:
	for i in button_list.get_children():
		i.queue_free()
	
	file_buttons.clear()

# Call each frame ( in process ) to get a double-clicked item, or null respectfully
func get_double_clicked():
	for selected in file_buttons:
		if selected.clicks >= 2:
			selected.clicks = 0
			return selected
	
	# TODO : fix opening of folder when first selection is a different button than second one
	return null

# loads button items based on entered path
func go_to_path(path : String) -> void:
	current_path = path
	load_items_from_path(path)

# returns the button id if a file or directory has been opened / selected
func get_selected_file_btn() -> Array[FileBtn]:
	var arr : Array[FileBtn] = []
	
	for b in file_buttons:
		if b.ui.button_pressed:
			arr.append(b)
	
	return arr

# Manages time for File Btns by adding delta to each, each frame
func manage_file_btn_times(delta : float):#
	for b in file_buttons:
		if b.selected_time >= DOUBLECLICK_TIME:
			b.clicks = 0
		
		if b.ui.button_pressed:
			b.selected_time += delta
		else:
			b.selected_time = 0

# Makes it, so only one item at a time is selected, if Shift is not held
func select_sinlg_ctrl():
	if Input.is_action_pressed("shift"):
		return
	
	# if not Input.is_action_just_pressed("click"): return
	
	var selected_btns = get_selected_file_btn()
	
	if selected_btns.size() < 2:
		return
	
	selected_btns.sort_custom(func(a, b): return a.selected_time < b.selected_time)
	for sid in range(1, selected_btns.size()):
		var s = selected_btns[sid]
		s.ui.button_pressed = false
	
	# return selected_btns[0]

# Returns true if path input is a valid file- or directory path
func is_path_valid(path : String) -> bool:
	return true
	
	var dir = DirAccess.open(path)
	if dir:
		return true
	
	return false

# TODO : Add search for files

func _on_file_path_text_submitted(new_text : String):
	# TODO : change this into the more suffisticated error popup system
	if not is_path_valid(new_text): print("ERROR : The path you entered is invalid"); return
	
	current_path = new_text
	# if current_path.ends_with("/"): current_path.replace() += "/" # Unify Path
	load_items_from_path(current_path)
	title_dir_edit.release_focus()

func exit():
	hide()
