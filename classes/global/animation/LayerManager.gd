extends Node



const LAYER_DATA = {
	"folder" :    {"color" : Color("ffffff"), "icon" : "res://ui/scene/video_editor/ui/icons/layer_types/folder.png"},
	"video" :     {"color" : Color("8cced1"), "icon" : "res://ui/scene/video_editor/ui/icons/layer_types/video.png"},
	"audio" :     {"color" : Color("d18c8c"), "icon" : "res://ui/scene/video_editor/ui/icons/layer_types/audio.png"},
	"effect" :    {"color" : Color("bbd18c"), "icon" : "res://ui/scene/video_editor/ui/icons/layer_types/effect.png"},
	"shape" :     {"color" : Color("d18ccf"), "icon" : "res://ui/scene/video_editor/ui/icons/layer_types/shape.png"},
	"image" :     {"color" : Color("8cd1b2"), "icon" : "res://ui/scene/video_editor/ui/icons/layer_types/image.png"},
	"animation" : {"color" : Color("8c9dd1"), "icon" : "res://ui/scene/video_editor/ui/icons/layer_types/keyframe.png"},
}

var layers : Array[AnimLayer] = []

var timeline = null

func add_layer(type : GLOBAL.LAYER_TYPE, tag : String = "unnamed", pos : int = -1): # TODO : Add parent input
	var layer = AnimLayer.new()
	layer.type = type
	layer.tag = tag
	layer.pos = pos
	
	var layer_type_str : String = GLOBAL.get_layer_name_from_type(type).to_lower()
	if layer_type_str == "null" : print("ERROR : tried to add layer of type, that is invalid in thye GLOBAL class. check GLOBAL class function : get_layer_name_from_type()..."); return
	
	# layer.make_layer_ui()
	layer.ui_data = LAYER_DATA[layer_type_str]
	layer.make_layer_ui()
	
	# Fix transform errors
	# ....
	
	# Add to global
	layers.append(layer)
	
	timeline.add_child(layer.ui)
	layer.ui.force_update_transform()
	
	if pos != -1:
		timeline.move_child(layer.ui, pos)
	
	print("Layer added : " + str(tag))
	
	return layer
	# pass # Add UI for new Layer, and add Layer to list

func move_layer(layer : AnimLayer, to : int):
	pass # Change psition valriable in class to 'to'

func delete_layer(layer : AnimLayer):
	pass # Remove ui and element from list

func animate_component(value : Value, layer : AnimLayer):
	pass # Create AnimKeyLayer and first key frame

func get_clip_from_ui(ui : Control):
	# TODO : Move to seperate thread
	for l in layers:
		for c in l.clips:
			if ui.name == str(c.UID):
				return c

func rescale_clips(scale : float, offset : float):
	var max_scroll = 0.0
	for l in layers:
		var s = 0.0
		for c in l.clips:
			s += c.length
		max_scroll = max(max_scroll, s)
	
	# """
	for l in layers:
		for c in l.clips:
			c.ui_rescale(scale)
		l.shift(offset * max_scroll)
	# """

func get_max_layer_width() -> float:
	var max_scroll = 0.0
	for l in layers:
		var s = 0.0
		for c in l.clips:
			s += c.length
		max_scroll = max(max_scroll, s)
	
	return max_scroll * GLOBAL.timeline_zoom
