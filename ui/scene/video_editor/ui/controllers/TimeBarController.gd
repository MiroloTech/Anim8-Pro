extends VBoxContainer

@onready var layers = $ScrollContainer/Layers
@onready var time_bar = $TimeBar/TimeBarLive

var time_bar_length : float = 0.0

func _process(_delta):
	for l in layers.get_children():
		if l is Panel:
			var content = l.get_node_or_null("LayerTagSplit/Contents/ContentList")
			
			if content == null:
				print("Layer Panel : " + l.name + " invalid")
				continue
			
			time_bar_length = max(time_bar_length, content.size.x)
	
	time_bar.size.x = time_bar_length
