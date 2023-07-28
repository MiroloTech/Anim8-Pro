extends Panel

@onready var dragger = $Dragger
@onready var time_tick_texture = $TextureRect
const start_pos = 120.0

func _process(delta):
	if dragger.button_pressed:
		dragger.global_position.x = get_global_mouse_position().x - 20
	
	var min_width = 0
	var max_width = size.x
	dragger.position.x = clampf(dragger.position.x, min_width-20, max_width-20)
	
	position.x = -(GLOBAL.timeline_drag_pos * GLOBAL.timeline_max_width) + start_pos
	time_tick_texture.scale.x = GLOBAL.timeline_zoom
