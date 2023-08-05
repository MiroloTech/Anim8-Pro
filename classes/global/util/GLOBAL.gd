extends Node

var project_path = "res://classes/global/project/pjinfo-video_test.json"

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

var FILE_TYPE = {
	"_" :     ["res://ui/scene/video_editor/ui/icons/file_icons/folder.png", Color("#fbb954")],
	"null" :  ["res://ui/scene/video_editor/ui/icons/file_icons/_.png",      Color("#2e222f")],
	
	"png" :   ["res://ui/scene/video_editor/ui/icons/file_icons/png.png",    Color("#1ebc73")],
	"jpg" :   ["res://ui/scene/video_editor/ui/icons/file_icons/jpg.png",    Color("#1ebc73")],
	
	"mp4" :   ["res://ui/scene/video_editor/ui/icons/file_icons/mp4.png",    Color("#905ea9")],
	"avi" :   ["res://ui/scene/video_editor/ui/icons/file_icons/avi.png",    Color("#905ea9")],
	"mpg" :   ["res://ui/scene/video_editor/ui/icons/file_icons/mpg.png",    Color("#905ea9")],
	"mov" :   ["res://ui/scene/video_editor/ui/icons/file_icons/mov.png",    Color("#905ea9")],
	"ogv" :   ["res://ui/scene/video_editor/ui/icons/file_icons/ogv.png",    Color("#905ea9")],
	"mkv" :   ["res://ui/scene/video_editor/ui/icons/file_icons/mkv.png",    Color("#905ea9")],
	
	# "a8scn" : preload(""), # Scene
	# "a8anm" : preload(""), # Animation
	# "a8xts" : preload(""), # Plug-In
	# "a8shd" : preload(""), # Shader
	
	"json" :  ["res://ui/scene/video_editor/ui/icons/file_icons/json.png",   Color("#ea4f36")],
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

func get_layer_type_from_name(tag : String) -> LAYER_TYPE:
	var type = -1
	if tag == "VIDEO":        type = LAYER_TYPE.VIDEO
	if tag == "AUDIO":       type = LAYER_TYPE.AUDIO
	if tag == "IMAGE":       type = LAYER_TYPE.IMAGE
	if tag == "EFFECT":      type = LAYER_TYPE.EFFECT
	if tag == "SHAPE":       type = LAYER_TYPE.SHAPE
	if tag == "FOLDER":      type = LAYER_TYPE.FOLDER
	if tag == "ANIMATION":   type = LAYER_TYPE.ANIMATION
	
	return type if type != -1 else -1


var timeline_zoom : float = 1.0
var timeline_drag_pos : float = 0.0
var timeline_max_width : float = 0.0
var timeline_vertical_offset : float = 0.0

var timeline_smoothing : float = 15.0
var timeline_zoom_power : float = 0.1

var timeline_vertical_dragger = null

func send_message_to_info_bar(msg : String):
	pass
