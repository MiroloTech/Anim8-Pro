extends Node

# all layer lypes
enum LAYER_TYPE {
	VIDEO,      # Video ( Collage of Frames )
	AUDIO,      # Audio PLayer
	IMAGE,      # Static Image
	EFFECT,     # Overlay Effect ( Shader )
	SHAPE,      # Text, Curve, etc.
	FOLDER,
	
	ANIMATION,  # Keyframe flow
}


func get_layer_name_from_type(type : LAYER_TYPE) -> String:
	var tag = ""
	if type == LAYER_TYPE.VIDEO:       tag = "VIDEO"
	if type == LAYER_TYPE.AUDIO:       tag = "AUDIO"
	if type == LAYER_TYPE.IMAGE:       tag = "IMAGE"
	if type == LAYER_TYPE.EFFECT:      tag = "EFFECT"
	if type == LAYER_TYPE.SHAPE:       tag = "SHAPE"
	if type == LAYER_TYPE.FOLDER:      tag = "FOLDER"
	if type == LAYER_TYPE.ANIMATION:   tag = "ANIMATION"
	
	return tag if tag != "" else "null"

var timeline_zoom : float = 1.0
var timeline_drag_pos : float = 0.0
var timeline_max_width : float = 0.0
var timeline_vertical_offset : float = 0.0

var timeline_smoothing : float = 15.0
var timeline_zoom_power : float = 0.1

var timeline_vertical_dragger = null

func send_message_to_info_bar(msg : String):
	pass
