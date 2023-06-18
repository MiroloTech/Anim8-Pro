extends VBoxContainer


func _process(delta):
	for c in get_children():
		if not c.name.ends_with('Children') and c is Panel:
			var opener_btn = c.get_node('LayerTagSplit/LayerTag/MarginContainer/HBoxContainer/Control/Opener')
			var open = opener_btn.button_pressed
			var layer_children = get_node_or_null(c.name + 'Children')
			if layer_children != null:
				opener_btn.show()
				for k in layer_children.get_children():
					k.custom_minimum_size.y = lerpf(k.custom_minimum_size.y, lerpf(0.0, 20.0, float(open)), delta * 15.0)
				
				# var sep = layer_children.get("theme_override_constants/separation")
				layer_children.visible = layer_children.scale.y > lerpf(0.99, 0.01, float(open))
				
				layer_children.scale.y = lerpf(layer_children.scale.y, float(open), delta * 15.0)
			else:
				opener_btn.hide()
