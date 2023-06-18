extends TextureButton


var target_opener_rotation : float = 180.0

func _process(delta):
	target_opener_rotation = 180.0 if button_pressed else 90.0
	
	rotation_degrees = lerpf(rotation_degrees, target_opener_rotation, delta * 15.0)
