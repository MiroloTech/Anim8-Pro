extends Node
class_name AnimClip
# BASE ANIMATION CLIP CLASS, NO DIRECT USE, USED AS A PRESET


# global variables
var UID : int = 0
var id : String = "0"
var type : GLOBAL.LAYER_TYPE
var is_ready : bool = false
var start_pos : float = 0.0
var length : float = 0.0
var ui : Control = null

func make_ui():
	var instance = preload("res://ui/scene/video_editor/ui/theme/instances/clip.tscn").instantiate()
	instance.custom_minimum_size = Vector2(length, 20)
	instance.modulate = GLOBAL.FILE_TYPE[GLOBAL.get_layer_name_from_type(type)][1]
	ui = instance

func ui_rescale(new_size : float = 1.0):
	ui.custom_minimum_size.x = length * new_size

