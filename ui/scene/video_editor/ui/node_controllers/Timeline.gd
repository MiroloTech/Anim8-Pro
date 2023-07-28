extends Control

# : Controls zoom input with scroll wheel

var mouse_in : bool = false
var target_zoom : float = 1.0


func _on_mouse_entered():
	mouse_in = true


func _on_mouse_exited():
	mouse_in = false



# Runs every frame
func _process(delta):
	var ctrl = Input.is_action_pressed("ctrl")
	
	if Input.is_action_just_released("scroll_up"):
		if ctrl:
			target_zoom += GLOBAL.timeline_zoom_power
		else:
			GLOBAL.timeline_vertical_dragger.shift(-25.0)
	if Input.is_action_just_released("scroll_down"):
		if ctrl:
			target_zoom -= GLOBAL.timeline_zoom_power
		else:
			GLOBAL.timeline_vertical_dragger.shift(25.0)
	
	target_zoom = clampf(target_zoom, 0.1, 10.0)
	GLOBAL.timeline_zoom = lerpf(GLOBAL.timeline_zoom, pow(target_zoom, 2.0), delta * GLOBAL.timeline_smoothing)

