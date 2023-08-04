extends Node
class_name Keyframe

# https://www.youtube.com/watch?v=5GMkZGcJpwM&list=RDMM&index=26 fits to BPM of caret

var time : float = 0.0
var value
var easing : float = 0.0
var ui_element : Button = null

func create_ui_elemnt():
	ui_element = preload("res://ui/scene/video_editor/ui/theme/instances/keyframe.tscn").instantiate()

func update_ui(scale : float = 1.0, offset : float = 0.0):
	ui_element.position.x = time * scale + offset
