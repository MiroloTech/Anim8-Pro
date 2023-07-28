extends VBoxContainer

@onready var layers = $ScrollContainer/Layers
@onready var time_bar = $TimeBar/TimeBarLive

var time_bar_length : float = 0.0

func _ready():
	LAYER_MANAGER.timeline = layers
	print(LAYER_MANAGER.timeline)
	
	for j in 3:
		for i in 7:
			var layer = LAYER_MANAGER.add_layer(i, "Test " + str(i+1)) # GLOBAL.LAYER_TYPE.VIDEO
			layer.add_clip_test(i * 100.0 * j)

func _process(_delta):
	for l in layers.get_children():
		if l is Panel:
			var content = l.get_node_or_null("LayerTagSplit/Contents/ContentList")
			
			if content == null:
				print("Layer Panel : " + l.name + " invalid")
				continue
			
			time_bar_length = max(time_bar_length, content.size.x)
	
	time_bar.size.x = time_bar_length


func _on_add_layer_pressed():
	INSTBUS.popup_manager.show_popup("LayerAddPopup")
