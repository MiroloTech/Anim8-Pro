extends Node

func create_controller(type):
	if type == TYPE_FLOAT:
		var control = Control.new()
		var spin_box = DragController.new()
		
		spin_box.drag_step = 0.01
		
		spin_box.set_anchors_preset(Control.PRESET_FULL_RECT)
		control.add_child(spin_box)
		return control
	
	if type == TYPE_INT:
		var control = Control.new()
		var spin_box = DragController.new()
		
		spin_box.drag_step = 0.1
		spin_box.rounded = true
		
		spin_box.set_anchors_preset(Control.PRESET_FULL_RECT)
		control.add_child(spin_box)
		return control
	
	if type == TYPE_BOOL:
		var control = Control.new()
		var check_box = CheckBox.new()
		
		check_box.focus_mode = Control.FOCUS_NONE
		
		check_box.set_anchors_preset(Control.PRESET_FULL_RECT)
		control.add_child(check_box)
		return control
	
	if type == TYPE_STRING:
		var control = Control.new()
		var edit = LineEdit.new()
		
		var style_box_focus = StyleBoxFlat.new()
		style_box_focus.bg_color = Color(0, 0, 0, 0)
		edit.set("theme_override_styles/focus", style_box_focus)
		edit.select_all_on_focus = true
		edit.set("theme_override_font_sizes/font_size", 12)
		
		edit.set_anchors_preset(Control.PRESET_FULL_RECT)
		control.add_child(edit)
		return control
	
	if type == TYPE_VECTOR2:
		var control = HBoxContainer.new()
		var x = DragController.new()
		var y = DragController.new()
		
		x.drag_step = 0.01
		y.drag_step = 0.01
		
		x.prefix = "x: "
		y.prefix = "y: "
		
		x.set_anchors_preset(Control.PRESET_FULL_RECT)
		y.set_anchors_preset(Control.PRESET_FULL_RECT)
		x.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		y.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control.add_child(x)
		control.add_child(y)
		return control
	
	if type == TYPE_VECTOR2I:
		var control = HBoxContainer.new()
		var x = DragController.new()
		var y = DragController.new()
		
		x.drag_step = 0.01
		y.drag_step = 0.01
		
		x.rounded = true
		y.rounded = true
		
		x.prefix = "x: "
		y.prefix = "y: "
		
		x.set_anchors_preset(Control.PRESET_FULL_RECT)
		y.set_anchors_preset(Control.PRESET_FULL_RECT)
		x.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		y.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control.add_child(x)
		control.add_child(y)
		return control
	
	if type == TYPE_VECTOR3:
		var control = HBoxContainer.new()
		var x = DragController.new()
		var y = DragController.new()
		var z = DragController.new()
		
		x.drag_step = 0.01
		y.drag_step = 0.01
		z.drag_step = 0.01
		
		x.prefix = "x: "
		y.prefix = "y: "
		z.prefix = "z: "
		
		x.set_anchors_preset(Control.PRESET_FULL_RECT)
		y.set_anchors_preset(Control.PRESET_FULL_RECT)
		z.set_anchors_preset(Control.PRESET_FULL_RECT)
		x.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		y.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		z.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control.add_child(x)
		control.add_child(y)
		control.add_child(z)
		return control
	
	if type == TYPE_VECTOR3I:
		var control = HBoxContainer.new()
		var x = DragController.new()
		var y = DragController.new()
		var z = DragController.new()
		
		x.drag_step = 0.01
		y.drag_step = 0.01
		z.drag_step = 0.01
		
		x.rounded = true
		y.rounded = true
		z.rounded = true
		
		x.prefix = "x: "
		y.prefix = "y: "
		z.prefix = "z: "
		
		x.set_anchors_preset(Control.PRESET_FULL_RECT)
		y.set_anchors_preset(Control.PRESET_FULL_RECT)
		z.set_anchors_preset(Control.PRESET_FULL_RECT)
		x.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		y.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		z.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control.add_child(x)
		control.add_child(y)
		control.add_child(z)
		return control
	
	if type == TYPE_COLOR:
		"""
		var control = Control.new()
		var color_edit = ColorPickerButton.new()
		
		var style_box_focus = StyleBoxFlat.new()
		style_box_focus.bg_color = Color(0, 0, 0, 0)
		color_edit.set("theme_override_styles/focus", style_box_focus)
		
		color_edit.set_anchors_preset(Control.PRESET_FULL_RECT)
		control.add_child(color_edit)
		return control
		"""
		
		var control = Control.new()
		var color_edit = preload("res://ui/custom_components/editing/color_picker_button.tscn").instantiate()
		
		# color_edit.set_anchors_preset(Control.PRESET_FULL_RECT)
		control.add_child(color_edit)
		return control
	
	# if type == TYPE_
	
	# TODO : Add TYPE_ARRAY, ENUM   ui
