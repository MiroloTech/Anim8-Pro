extends Control

@onready var TypeMenuBtn = $MarginContainer/Content/TypeSelector/TypeButton
@onready var TypeMenuLbl = $MarginContainer/Content/TypeSelector/TypeLabel
@onready var TypeMenuClr = $MarginContainer/Content/TypeSelector/TypeColor.get("theme_override_styles/panel")

@onready var NameInput = $MarginContainer/Content/LayerName
@onready var AcceptBtn = $MarginContainer/Content/AcceptButton/Accept

var layer_name = ""
var layer_type = {}

# Gets run at ready state of application
func _ready():
	# Set all layer types
	var popup = TypeMenuBtn.get_popup()
	popup.id_pressed.connect(Callable(self, "item_selected"))
	
	for type in LAYER_MANAGER.LAYER_DATA:
		popup.add_item(type)

# Runs every frame
func _process(_delta):
	set_layer_name()
	update_is_acceptable()

func set_layer_name():
	layer_name = NameInput.text

func item_selected(id : int):
	var key = LAYER_MANAGER.LAYER_DATA.keys()[id]
	var val = LAYER_MANAGER.LAYER_DATA.get(key)
	layer_type = {key : val}
	TypeMenuLbl.text = key
	TypeMenuClr.set("bg_color", val.get("color"))

# Disables the 'Accept' Button when the inputted values are invalid
func update_is_acceptable():
	var valid = is_valid()
	AcceptBtn.disabled = not valid
	
	AcceptBtn.mouse_default_cursor_shape = CURSOR_POINTING_HAND if valid else CURSOR_FORBIDDEN

# Returns true if the all values are valid
func is_valid() -> bool:
	if layer_name == "":
		return false
	
	if layer_type.is_empty():
		return false
	
	return true



func _on_exit_pressed():
	hide()


func _on_accept_pressed():
	print(layer_type)
	var type_str = layer_type.keys()[0].to_upper()
	var type : int = GLOBAL.get_layer_type_from_name(type_str)
	var new_layer : AnimLayer = LAYER_MANAGER.add_layer(type, layer_name)
	new_layer.ui.position.y = 0
	new_layer.ui.update_minimum_size()
	print(new_layer)
	hide()
	# TODO : Reset all values
