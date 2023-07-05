extends Panel

@onready var dragger = $Dragger

func _process(_delta):
	if dragger.button_pressed:
		dragger.global_position.x = get_global_mouse_position().x - 20
	
	var min_width = 0
	var max_width = size.x # TODO : set to maximum film time
	dragger.position.x = clampf(dragger.position.x, min_width-20, max_width-20)
