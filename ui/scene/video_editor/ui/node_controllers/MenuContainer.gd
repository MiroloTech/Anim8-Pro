extends Control

@onready var buttons : Array[Node] = $Menus.get_children()
@onready var selection = $Selection

var target_button : TextureButton = null
var target_btn_id : int = 0

func _ready():
	target_button = buttons[0]

func _process(delta):
	for bid in buttons.size():
		var b = buttons[bid]
		if b.button_pressed:
			target_btn_id = bid
			target_button = b
	
	if target_button != null:
		selection.position.y = lerpf(selection.position.y, target_button.position.y + 6, delta * 20.0)
