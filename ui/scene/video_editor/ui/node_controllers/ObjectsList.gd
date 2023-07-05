extends Control

@onready var tree = $MarginContainer/Content/Tree

# Runs at start of program
func _ready():
	dir2tree()

# Makes a tree out of a directory in file system
var items = {}

enum TREE_ITEM_TYPE {
	DIR,
	FILE
}

var root_item : treeItem = null
var tree_items : Array[treeItem] = []

class treeItem:
	var path : String = ""
	var item : TreeItem = null

func dir2tree():
	root_item = treeItem.new()
	root_item.item = tree.create_item(null)
	var file_paths = get_file_paths_in_directory("res://classes/objects/objects/", "")
	
	for f in file_paths:
		var splitted_path : Array = Array(f.split("/"))
		splitted_path.erase(splitted_path[0])
		var current_path : String = ""
		var last_item : treeItem = root_item
		for p in splitted_path:
			current_path += "/" + p
			var tree_item_existed : bool = false
			for ti in tree_items:
				if ti.path == current_path:
					tree_item_existed = true
					last_item = ti
			if not tree_item_existed:
				var ti = treeItem.new()
				ti.path = current_path
				var type = TREE_ITEM_TYPE.FILE if p.ends_with('.gd') else TREE_ITEM_TYPE.DIR
				ti.item = create_item(p, last_item.item, type, current_path)
				last_item = ti
				tree_items.append(ti)

# Gets all files in a folder, including sub-files
func get_file_paths_in_directory(main_path : String, dir_path : String) -> Array[String]:
	var file_paths: Array[String] = []
	var dir = DirAccess.open(main_path + dir_path)
	
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			var file_path = dir_path + "/" + file_name
			
			if dir.current_is_dir():
				var sub_directory = dir_path + "/" + file_name
				var sub_file_paths = get_file_paths_in_directory(main_path, sub_directory)
				file_paths.append_array(sub_file_paths)
			else:
				file_paths.append(file_path)
			
			file_name = dir.get_next()
	else:
		print("Error opening directory: " + dir_path)
	
	return file_paths

# Cuts out filename of path
func get_file_name(path: String) -> String:
	var separator = path.rfind("/")
	return path.substr(separator + 1) if separator >= 0 else path

# Creates new item for tree
func create_item(n : String, parent : TreeItem, type : TREE_ITEM_TYPE = TREE_ITEM_TYPE.FILE, path : String = "") -> TreeItem:
	# Create basic instance
	var item : TreeItem = tree.create_item(parent)
	n = n.replace(".gd", "")
	item.set_text(0, n)
	
	# Set icon
	if type == TREE_ITEM_TYPE.FILE: # Loading inefficient !!!
		var dir = "res://ui/scene/video_editor/ui/icons/inspector/object_list/obj_icons/"
		var icon_path_list = get_file_paths_in_directory(dir, "")
		var most_simmilar_icon = STRUTIL.get_most_simmilar(n, icon_path_list)
		var icon = load(dir + most_simmilar_icon)
		item.set_icon(0, icon)
		item.set_icon_modulate(0, Color('BBBBBB'))
	elif type == TREE_ITEM_TYPE.DIR:
		var icon = preload("res://ui/scene/video_editor/ui/icons/files/folder.png")
		item.set_icon(0, icon)
		item.set_icon_modulate(0, Color('444444'))
		item.set_selectable(0, false)
	
	item.set_icon_max_width(0, 16)
	item.set_tooltip_text(0, " ")
	
	# Add to list
	if path != "":
		items.merge({item : [path, type]}, true)
	
	# return
	return item
