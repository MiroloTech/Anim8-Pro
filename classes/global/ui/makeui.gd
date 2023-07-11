extends Node

var valid_types = [
	TYPE_FLOAT,
	TYPE_INT,
	TYPE_BOOL,
	TYPE_STRING,
	TYPE_VECTOR2,
	TYPE_VECTOR2I,
	TYPE_VECTOR3,
	TYPE_VECTOR3I,
	TYPE_COLOR,
]

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

func get_controller_value(controller_parent):
	var ctrl = controller_parent.get_child(0)
	if ctrl == null: return # TODO : Add error message
	# TODO : imrpove error message handleing and show them in editor as popup
	
	if ctrl is DragController:
		return int(ctrl.value) if ctrl.rounded else ctrl.value
	
	if ctrl is CheckBox:
		return ctrl.button_pressed
	
	if ctrl is LineEdit:
		return ctrl.text
	
	if ctrl is HBoxContainer:
		var values : Array = []
		var is_int : bool = false
		for c in ctrl.get_children():
			if not c is DragController: continue
			
			is_int = bool(max(int(c.rounded), int(is_int)))
			
			values.append(c.values)
		
		if values.size() == 2:
			if is_int: return Vector2i(values[0], values[1])
			else:      return  Vector2(values[0], values[1])
		elif values.size() == 3:
			if is_int: return Vector3i(values[0], values[1], values[2])
			else:      return  Vector3(values[0], values[1], values[2])
	
	if ctrl is CustomColorPicker:
		return ctrl.color

func set_controller_value(controller_parent, value):
	var ctrl = controller_parent.get_child(0)
	if ctrl == null: return # TODO : Add error message
	# TODO : imrpove error message handleing and show them in editor as popup
	
	if ctrl is DragController and [TYPE_INT, TYPE_FLOAT].has(typeof(value)):
		ctrl.set_value(value)
	
	if ctrl is CheckBox and [TYPE_BOOL].has(typeof(value)):
		ctrl.button_pressed = value
	
	if ctrl is LineEdit and [TYPE_STRING].has(typeof(value)):
		ctrl.text = value
	
	if ctrl is HBoxContainer and [TYPE_VECTOR2, TYPE_VECTOR2I, TYPE_VECTOR3, TYPE_VECTOR3I].has(typeof(value)): # TODO : Do this and next
		var values : Array = []
		var is_int : bool = [TYPE_VECTOR2I, TYPE_VECTOR3I].has(typeof(value))
		for cid in ctrl.get_children().size():
			var c = ctrl.get_children([cid])
			if not c is DragController: continue
			
			is_int = bool(max(int(c.rounded), int(is_int)))
			
			c.set_value(value.x if cid == 0 else (value.y if cid == 1 else value.z))
	
	if ctrl is CustomColorPicker and [TYPE_COLOR].has(typeof(value)):
		ctrl.set_color(value)

func connect_controller_to_value_changed(controller, function : Callable):
	var ctrl = controller.get_child(0)
	if ctrl == null: return # TODO : Add error message
	# TODO : imrpove error message handleing and show them in editor as popup
	
	if ctrl is DragController:
		ctrl.connect("value_changed", function)
	
	if ctrl is CheckBox:
		ctrl.connect("toggled", function)
	
	if ctrl is LineEdit:
		ctrl.connect("text_changed", function)
	
	if ctrl is HBoxContainer: # TODO : Do this and next
		for c in ctrl.get_children():
			if not c is DragController: continue
			
			c.connect("value_changed", function)
	
	if ctrl is CustomColorPicker:
		ctrl.connect("value_changed", function)
