extends Control

@onready var preview = $ColorPicker
@onready var button = $Button

var color : Color = Color.BLACK

func _on_button_pressed():
	preview.visible = not preview.visible

func _process(_delta):
	color = preview.color
	
	var style_normal = button.get("theme_override_styles/normal")
	var style_hover = button.get("theme_override_styles/hover")
	var style_pressed = button.get("theme_override_styles/pressed")
	
	style_normal.bg_color = color
	style_hover.bg_color = color
	style_pressed.bg_color = color
	
	preview.global_position = global_position + Vector2(0.0, button.size.y)
	# preview.size = Vector2(button.size.x, button.size.x * 2.0)
