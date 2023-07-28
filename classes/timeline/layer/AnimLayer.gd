extends Node
class_name AnimLayer

var tag : String = "unnamed"
var pos : int = 0
var type : GLOBAL.LAYER_TYPE
var clips : Array[AnimClip] = []
var children : Array[AnimKeyLayer] = []
var is_ready : bool = false
var ui : Control = null
var color : Color = Color.BLACK
var icon : Image
var ui_data : Dictionary = {}

# TODO : Make base Layer class and move this function to it
func make_layer_ui():
	if ui_data.is_empty(): print("ERROR : tried to create layer UI before defining specific ui data... layer ui creation will continue without additional data")
	else:
		color = ui_data.color
		icon = Image.load_from_file(ui_data.icon)
	
	var instance = preload("res://ui/scene/video_editor/ui/theme/instances/layer.tscn").instantiate()
	var has_children_switch = children.size() > 0
	
	var layer_opener = instance.get_node("LayerTagSplit/LayerTag/MarginContainer/HBoxContainer/Control/Opener")
	var icon_texture = instance.get_node("LayerTagSplit/LayerTag/MarginContainer/TypeIcon")
	var title_label = instance.get_node("LayerTagSplit/LayerTag/MarginContainer/HBoxContainer/Title")
	
	layer_opener.visible = has_children_switch
	layer_opener.mouse_filter = Control.MOUSE_FILTER_STOP if has_children_switch else Control.MOUSE_FILTER_IGNORE
	
	var img_texture = ImageTexture.new()
	img_texture.set_image(icon)
	icon_texture.texture = img_texture
	
	title_label.text = tag
	
	ui = instance

func shift(to : float):
	ui.get_node("LayerTagSplit/Contents/ContentList").position.x = -to

func add_clip_test(length : float):
	var clip = AnimClip.new()
	clip.length = length
	clip.make_ui()
	clips.append(clip)
	clip.ui.modulate = color
	
	ui.get_node("LayerTagSplit/Contents/ContentList").add_child(clip.ui)

