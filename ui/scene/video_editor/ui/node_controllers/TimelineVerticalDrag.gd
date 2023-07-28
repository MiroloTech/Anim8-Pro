extends Control

var pos : float = 0.0 # 0.0 - 1.0
var target_pos : float = 0.0
var width : float = 250.0 # Width of button
var dragging : bool = false
var can_drag : bool = false

@onready var button = $Button
@onready var layers = $"../../MarginContainer/TimeSplit/ScrollContainer/Layers"

func _enter_tree():
	GLOBAL.timeline_vertical_dragger = self

func _process(delta):
	# TODO : fix double movement in vertical scroll
	
	# pos = clampf(pos, 0.0, 1.0)
	# print(pos)
	
	#if button.button_pressed:
	#	move_dragger_to(get_global_mouse_position().x)
	
	if target_pos == 0.0:
		target_pos = global_position.y
	
	if Input.is_action_pressed("click"):
		var mpos = get_global_mouse_position()
		var in_bounds = mpos == mpos.clamp(global_position, global_position + size)
		
		if Input.is_action_just_pressed("click") and in_bounds:
			can_drag = true
		
		if (in_bounds or dragging) and can_drag:
			dragging = true
			move_dragger_to(mpos.y)
	else:
		dragging = false
		can_drag = false
	
	
	# var zoom = 1.0 / (width / 250.0) # TODO : do zoom stuff
	var max_width = layers.get_child_count() * ( 20.0 + layers.get("theme_override_constants/separation") )
	# Set width from zoom
	button.size.y = width
	
	var visable_max = size.y
	var width_percentage = min(visable_max / max(max_width, 1.0), 1.0)
	width = width_percentage * visable_max
	
	# Move dragger smoothly towards target
	# print(target_pos)
	button.global_position.y = lerpf(button.global_position.y, target_pos, delta * GLOBAL.timeline_smoothing)
	
	# Set pos value
	var min = global_position.y
	var max = min + size.y - width
	pos = (button.global_position.y - min) / (max - min)
	if pos == -INF: pos = 0.0
	
	# Apply drag changes
	# LAYER_MANAGER.rescale_clips(GLOBAL.timeline_zoom, GLOBAL.timeline_drag_pos)
	
	layers.position.y = -(pos * max_width)



func shift(offset : float):
	var t = button.global_position.y + offset
	# print(t)
	# move_dragger_to(t)
	var min = global_position.y
	var max = min + size.y - width
	
	t = clampf(t, min, max)
	target_pos = t
	

func set_pos(to : float):
	pos = to
	
	var min = global_position.y
	var max = min + size.y - width
	
	move_dragger_to(lerpf(min, max, pos))

func move_dragger_to(to : float):
	var click_pos = to - (width / 2.0)
	
	var min = global_position.y
	var max = min + size.y - width
	
	var target = clampf(click_pos, min, max)
	target_pos = target

