extends Control

var pos : float = 0.0 # 0.0 - 1.0
var target_pos : float = 0.0
var width : float = 250.0 # Width of button
var dragging : bool = false
var can_drag : bool = false

@onready var button = $Button

func _process(delta):
	# if target_pos == 0.0:
	# 	target_pos = global_position.x
	
	# pos = clampf(pos, 0.0, 1.0)
	
	#if button.button_pressed:
	#	move_dragger_to(get_global_mouse_position().x)
	
	if Input.is_action_pressed("click"):
		var mpos = get_global_mouse_position()
		var in_bounds = mpos == mpos.clamp(global_position, global_position + size)
		
		if Input.is_action_just_pressed("click") and in_bounds:
			can_drag = true
		
		if (in_bounds or dragging) and can_drag:
			dragging = true
			move_dragger_to(mpos.x)
	else:
		dragging = false
		can_drag = false
	
	
	# var zoom = 1.0 / (width / 250.0) # TODO : do zoom stuff
	var max_width = LAYER_MANAGER.get_max_layer_width()
	# GLOBAL.timeline_zoom = zoom
	GLOBAL.timeline_max_width = max_width
	GLOBAL.timeline_drag_pos = pos
	# Set width from zoom
	button.size.x = width
	
	var visable_max = size.x
	var width_percentage = min(visable_max / max(max_width, 1.0), 1.0)
	width = width_percentage * visable_max
	
	# Move dragger smoothly towards target
	button.global_position.x = lerpf(button.global_position.x, target_pos, delta * GLOBAL.timeline_smoothing)
	var min = global_position.x
	var max = min + size.x - width
	pos = (button.global_position.x - min) / (max - min)
	if pos == -INF: pos = 0.0
	
	# Apply drag changes
	LAYER_MANAGER.rescale_clips(GLOBAL.timeline_zoom, GLOBAL.timeline_drag_pos) #this might be a problem

func move_dragger_to(to : float):
	var click_pos = to - (width / 2.0)
	
	var min = global_position.x
	var max = min + size.x - width
	
	var target = clampf(click_pos, min, max)
	target_pos = target



func _on_resized():
	# move_dragger_to()
	pass
