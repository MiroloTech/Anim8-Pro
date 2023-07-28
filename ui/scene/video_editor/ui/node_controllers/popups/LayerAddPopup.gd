extends Control

@onready var TypeMenuBtn = $MarginContainer/Content/TypeSelector/TypeButton
@onready var TypeMenuLbl = $MarginContainer/Content/TypeSelector/TypeLabel
@onready var TypeMenuClr = $MarginContainer/Content/TypeSelector/TypeColor.get("theme_override_styles/panel")


# Gets run at ready state of application
func _ready():
	# Set all layer types
	var popup = TypeMenuBtn.get_popup()
	popup.id_pressed.connect(Callable(self, "item_selected"))
	
	for type in LAYER_MANAGER.LAYER_DATA:
		popup.add_item(type)

func item_selected(id : int):
	var key = LAYER_MANAGER.LAYER_DATA.keys()[id]
	var val = LAYER_MANAGER.LAYER_DATA.get(key)
	TypeMenuLbl.text = key
	TypeMenuClr.set("bg_color", val.get("color"))


func _on_exit_pressed():
	hide()
