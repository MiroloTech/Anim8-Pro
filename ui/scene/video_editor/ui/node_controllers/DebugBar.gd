extends Panel

@onready var root = get_tree().root
@onready var label = $MarginContainer/Label

var described_nodes : Array[Control] = []

func _ready():
	find_all_with_editor_description(root, described_nodes)

func _process(_delta):
	label.text = ""
	show_descriptions()

func show_descriptions():
	for i in described_nodes:
		if i is BaseButton:
			if i.is_hovered() and not i.disabled:
				label.text = "> " + str(i.editor_description)

func find_all_with_editor_description(node: Node, result : Array) -> void:
	if node.editor_description != "":
		result.push_back(node)
	for child in node.get_children():
		find_all_with_editor_description(child, result)
