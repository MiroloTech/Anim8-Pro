extends Control
class_name AdvancedSettings

@export var funcion_parents : Array[Node] = []

var option_menu : Control = null
var option_btns : Array[Array] = []
var open : bool = false

const BOUND_OFFSET = Vector2(60, 60)

func _ready():
	# Setup Controller to more user-friendly settings
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	return
	
	# Test MAKEUI's popup function
	var popup = POPGEN.new(
		"Test",
		[
			["text"      ,TYPE_STRING, "bla bla bla"],
			["floating"  ,TYPE_FLOAT],
			["number"    ,TYPE_INT],
			["true?"     ,TYPE_BOOL, false],
			["position"  ,TYPE_VECTOR2, Vector2(20, -0.85)]
		],
	)
	popup.connect('output', Callable(self, 'test_output'))
	
	GLOBAL.add_child(popup)

func test_output(args : Array):
	print(args)

# Runs every frame
func _process(delta):
	# Check if option menu has to be opened 
	if Input.is_action_just_pressed("right_click") and not open:
		var mpos : Vector2 = get_global_mouse_position()
		var bounds : Array[Vector2]= [global_position, global_position + size]
		
		if mpos == mpos.clamp(bounds[0], bounds[1]):
			open_options()
	
	if open:
		var mpos : Vector2 = get_global_mouse_position()
		var min = option_menu.global_position - BOUND_OFFSET
		var max = option_menu.global_position + option_menu.size + BOUND_OFFSET
		
		if mpos != mpos.clamp(min, max):
			close_options()
	
	manage_calls()

# TODO : Add this
func open_options():
	open = true
	
	option_menu = Panel.new()
	option_menu.name = "OptionMenu"
	option_menu.global_position = get_global_mouse_position()
	option_menu.custom_minimum_size.y = 160
	add_child(option_menu)
	
	var scroll_container = ScrollContainer.new()
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	option_menu.add_child(scroll_container)
	
	var option_container = VBoxContainer.new()
	option_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.set("theme_override_constants/separation", 1)
	scroll_container.add_child(option_container)
	
	
	var max_width = 0.0
	
	for p in funcion_parents:
		var base_class = p.get_class()
		var built_in_methods = ClassDB.class_get_method_list(base_class)
		var built_in_method_names : Array[String] = []
		
		for bm in built_in_methods:
			built_in_method_names.append(bm.name)
		
		var methods = p.get_method_list()
		for m in methods:
			if m.name.begins_with("_"): continue
			if built_in_method_names.has(m.name): continue
			
			var btn = Button.new()
			var btn_text : String = m.name
			btn_text = btn_text.replace("_", " ")
			btn.text = btn_text
			
			btn.name = m.name
			btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
			btn.focus_mode = Control.FOCUS_NONE # Maybe remove this
			btn.set("theme_override_font_sizes/font_size", 12)
			
			option_container.add_child(btn)
			option_btns.append([btn, p, m.duplicate()])
			
			# btn.force_update_transform()
			
			max_width = max(max_width, btn.size.x + 20)
	
	scroll_container.force_update_transform()
	option_menu.custom_minimum_size.x = max_width
	option_menu.top_level = true

func manage_calls():
	for b in option_btns:
		var btn = b[0]
		var parent = b[1]
		var method_data = b[2]
		if btn.button_pressed: # FIXME : Pressed calls multiple times
			var call = Callable(parent, btn.name)
			# Popup Custom Mennu for arguments here, if at least one argument is epected
			if method_data.args.size() == 0:
				call.call()
			else:
				var args = []
				
				# var ext = ScriptExtension.new()
				# get_method_info()
				# print(call.get_bound_arguments())
				
				# TODO : Wait for fix, with better argument names
				for arg in method_data.args:
					print(arg)
					args.append([arg.name, TYPE_STRING])
				
				var popup = POPGEN.new(btn.name, args)
				GLOBAL.add_child(popup)
				
				popup.connect('output', Callable(self, 'option_called').bind(call))
			
			close_options()

func option_called(args : Array, call : Callable):
	call.callv(args)

func close_options():
	option_menu.queue_free()
	
	option_btns.clear()
	open = false
