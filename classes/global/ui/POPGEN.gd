extends Node
class_name POPGEN

signal output()

var main : Control = null
var controller : Array[Control] = []

func _init(title : String, args : Array):
	main = Panel.new()
	main.name = title
	main.custom_minimum_size = Vector2(460, 320)
	main.position = Vector2(DisplayServer.window_get_size(0) / 2) - (main.custom_minimum_size / 2)
	# main.z_index = 99
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.set("theme_override_constants/margin_left", 6)
	margin.set("theme_override_constants/margin_top", 6)
	margin.set("theme_override_constants/margin_right", 6)
	margin.set("theme_override_constants/margin_bottom", 6)
	main.add_child(margin)
	
	var title_seperator = VBoxContainer.new()
	title_seperator.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_child(title_seperator)
	
	var title_container = HBoxContainer.new()
	title_seperator.add_child(title_container)
	
	var title_lbl = Label.new()
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_lbl.text = title
	title_lbl.set("theme_override_font_size", 12)
	title_lbl.modulate = Color("757575")
	title_container.add_child(title_lbl)
	
	var close_btn = TextureButton.new()
	close_btn.set_script(preload("res://ui/scene/video_editor/ui/node_controllers/TextureButton.gd"))
	close_btn.texture_normal = preload("res://ui/scene/video_editor/ui/icons/popups/cross-small.png")
	close_btn.ignore_texture_size = true
	close_btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	close_btn.custom_minimum_size.x = 16
	close_btn.connect('pressed', Callable(self, 'exit'))
	title_container.add_child(close_btn)
	
	var content_list = VBoxContainer.new()
	content_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_seperator.add_child(content_list)
	
	for a in args:
		var has_setter = a.size() == 3
		var var_name = a[0]
		
		var component = MAKEUI.create_controller(a[1])
		component.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		if has_setter:
			MAKEUI.set_controller_value(component, a[2])
		
		controller.append(component)
		
		var var_container = HBoxContainer.new()
		var_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var var_label = Label.new()
		var_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		var_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var_label.text = var_name
		var_label.set("theme_override_font_sizes/font_size", 12)
		var_label.modulate = Color("dddddd")
		
		var_container.add_child(var_label)
		var_container.add_child(component)
		
		content_list.add_child(var_container)
	
	var accept_button = Button.new()
	accept_button.text = "Confirm"
	accept_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	accept_button.focus_mode = Control.FOCUS_NONE
	accept_button.set("theme_override_font_size", 12)
	accept_button.set("theme_override_colors/font_color", Color("878787"))
	accept_button.connect('pressed', Callable(self, 'accept'))
	title_seperator.add_child(accept_button)
	
	add_child(main)
	main.top_level = true

func exit():
	main.hide()
	main.queue_free()

func accept():
	var result = []
	for c in controller:
		var r = MAKEUI.get_controller_value(c)
		result.append(r)
	
	emit_signal('output', result)
	exit()
