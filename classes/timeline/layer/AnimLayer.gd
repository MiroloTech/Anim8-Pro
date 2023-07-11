extends Node
class_name AnimLayer

# all layer lypes
enum LAYER_TYPE {
	VIDEO,      # Video ( Collage of Frames )
	IMAGE,      # Static Image
	EFFECT,     # Overlay Effect ( Shader )
	SHAPE,      # Text, Curve, etc.
	
	ANIMATION,  # Keyframe flow
}

var tag : String = "unnamed"
var pos : int = 0
var type : LAYER_TYPE
var clips : Array[AnimClip] = []
var children : Array[AnimKeyLayer] = []
var is_ready : bool = false
var ui : Control = null

# TODO : Make base Layer class and move this function to it
func make_layer_ui():
	var instance = preload("res://ui/scene/video_editor/ui/theme/instances/layer.tscn").instantiate()
	var has_children_switch = children.size() > 0
	
	var layer_opener = instance.get_node("LayerTagSplit/LayerTag/MarginContainer/HBoxContainer/Control/Opener")
	var title_label = instance.get_node("LayerTagSplit/LayerTag/MarginContainer/HBoxContainer/Title")
	
	layer_opener.visible = has_children_switch
	layer_opener.mouse_filter = Control.MOUSE_FILTER_STOP if has_children_switch else Control.MOUSE_FILTER_IGNORE
	
	title_label.text = tag
	
	ui = instance
