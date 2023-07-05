extends TextureButton

@export var color_base : Color = Color('a8a8a8')
@export var color_hovered : Color = Color('e1e1e1')
@export var color_pressed : Color = Color('707070')
@export var color_disabled : Color = Color('4b4b4b')


func _process(_delta):
	if is_hovered():
		if button_pressed:
			modulate = color_pressed
		else:
			modulate = color_hovered
	
	else:
		modulate = color_base
	
	if disabled:
		modulate = color_disabled
