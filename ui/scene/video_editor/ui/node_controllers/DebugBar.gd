extends Panel

@onready var root = get_tree().root
@onready var label = $MarginContainer/Label

var described_nodes : Array[Control] = []

var infos : Dictionary = {}

var prefix : String = ""
var suffix : String = ""

var in_priority_access : bool = false # Disables clearing and overriding of message by node hints

# Runs at init of program
func _enter_tree():
	# Set global instance for global acces
	INSTBUS.bottom_bar = self

# Runs at first frame of program
func _ready():
	# Finds all Nodes, that have an editor description
	find_all_with_editor_description(root, described_nodes)

# Runs every frame
func _process(_delta):
	if not in_priority_access:
		label.text = ""
		show_descriptions()
	else:
		label.text = prefix
		
		for ik in infos.keys():
			var i = infos[ik]
			label.text += i + (", " if i == infos[infos.keys()[infos.size()-1]] else "...")
		
		label.text += suffix

# Shows the editor description in bar, if node is hovered
func show_descriptions():
	for i in described_nodes:
		if i is BaseButton:
			if i.is_hovered() and not i.disabled:
				label.text = "> " + str(i.editor_description)

# Recursivly finds all nodes with an editor description
func find_all_with_editor_description(node: Node, result : Array, depth : int = 0) -> void:
	if depth > 50:
		return
	if node.editor_description != "":
		result.push_back(node)
	for child in node.get_children():
		find_all_with_editor_description(child, result, depth + 1)

# Clears message from bar
func clear_info(id : int):
	infos.erase(id)
	
	if infos.is_empty():
		in_priority_access = false
		label.text = ""

# Sets the bar text to custom
func add_info(custom : String, id : int):
	infos[id] = custom
	# Clear old
	in_priority_access = true
	label.text = ""


# Sets prefix and suffix
func set_ps(p : String, s : String):
	prefix = p
	suffix = s

# Resets prefix and suffix back to empty
func clear_ps():
	prefix = ""
	suffix = ""
