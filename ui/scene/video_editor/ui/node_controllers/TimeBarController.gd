extends VBoxContainer

@onready var layers = $ScrollContainer/Layers
@onready var time_bar = $TimeBar/Content/TimeBar/TimeBarLive
@onready var layer_ctrl = $TimeBar/Content/LayerControl
@onready var time_bar_ctrl = $TimeBar/Content/TimeBar

var time_bar_length : float = 0.0
var temp_layer_ui = null

func _ready():
	LAYER_MANAGER.timeline = layers
	print(LAYER_MANAGER.timeline)
	
	temp_layer_ui = load("res://ui/scene/video_editor/ui/theme/instances/layer.tscn").instantiate()
	
	"""
	for j in 3:
		for i in 7:
			var layer = LAYER_MANAGER.add_layer(i, "Test " + str(i+1)) # GLOBAL.LAYER_TYPE.VIDEO
			# layer.add_clip_test((i+1) * 100.0 * j)
	# """

func _process(_delta):
	for l in layers.get_children():
		if l is Panel:
			var content = l.get_node_or_null("LayerTagSplit/Contents/ContentList")
			
			if content == null:
				print("Layer Panel : " + l.name + " invalid")
				continue
			
			time_bar_length = max(time_bar_length, content.size.x)
	
	time_bar.size.x = time_bar_length
	
	# Set layer_ctrl min_width to the width of the layer text widget
	var widget = temp_layer_ui.get_node("LayerTagSplit/LayerTag")
	var width = widget.custom_minimum_size.x
	layer_ctrl.custom_minimum_size.x = width
	time_bar_ctrl.position.x = 60


func _on_add_layer_pressed():
	INSTBUS.popup_manager.show_popup("LayerAddPopup")
