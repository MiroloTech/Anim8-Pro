extends Control

@onready var container = $MarginContainer/ContentContainer/SmoothScrollContainer/GridContainer

var active_controllers : Array = []

func _ready():
	# TEST
	# change array to list of Value classes
	var arr = [
		["float", TYPE_FLOAT],
		["int", TYPE_INT],
		["bool", TYPE_BOOL],
		["string", TYPE_STRING],
		["vec2", TYPE_VECTOR2],
		["vec2i", TYPE_VECTOR2I],
		["vec3", TYPE_VECTOR3],
		["vec3i", TYPE_VECTOR3I],
		["color", TYPE_COLOR],
	]
	
	load_controllers(arr)

func load_controllers(ctrls : Array):
	for c in ctrls:
		var label = Label.new()
		label.set("theme_override_font_sizes/font_size", 12)
		label.text = c[0]
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		var controller = MAKEUI.create_controller(c[1])
		controller.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		controller.size_flags_vertical = Control.SIZE_FILL
		
		container.add_child(label)
		container.add_child(controller)
		active_controllers.append(controller)
