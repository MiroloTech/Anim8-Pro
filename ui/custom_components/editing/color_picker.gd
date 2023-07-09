extends Control

# TODO : Clean Up (ReWrite)
# FIX : HEX input not working

@onready var color_preview_texture = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var hue_preview_texture = $MarginContainer/VBoxContainer/HBoxContainer/TextureRectHue
@onready var preview = $MarginContainer/VBoxContainer/VBoxContainer/Preview

@onready var color_preview_drag = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Dragger
@onready var hue_preview_drag = $MarginContainer/VBoxContainer/HBoxContainer/TextureRectHue/Dragger

@onready var input_type_controller = $MarginContainer/VBoxContainer/VBoxContainer/Control

@export var color = Color.BLACK

const IMG_SIZE = 16
enum COLOR_TYPE_UPDATE_TYPES {RGB, HSV, HEX}

var hue = 0.0
var saturation = 0.0
var value = 0.0

var red = 0.0
var green = 0.0
var blue = 0.0

var controllers = {}

var active : bool = false

func input_changed(new_value, tag : String):
	# print(tag + " changed to : " + str(new_value))
	if tag == "R":
		red = float(new_value) / 256.0
	if tag == "G":
		green = float(new_value) / 256.0
	if tag == "B":
		blue = float(new_value) / 256.0
	
	if tag == "H":
		hue = float(new_value) / 256.0
	if tag == "S":
		saturation = float(new_value) / 256.0
	if tag == "V":
		value = float(new_value) / 256.0
	
	if ["H", "S", "V"].has(tag):
		update_color_from_local_variables(COLOR_TYPE_UPDATE_TYPES.HSV)
	if ["R", "G", "B"].has(tag):
		update_color_from_local_variables(COLOR_TYPE_UPDATE_TYPES.RGB)
	
	if tag == "HEX":
		color = new_value # Color.from_string(new_value, Color(99, 99, 99))
		update_color_from_local_variables(COLOR_TYPE_UPDATE_TYPES.HEX, false)
		# update()
	
	# update()
	# update_h_drag()
	# update_vs_drag()
	
	set_controllers(false)
	
	update()
	
	# TODO : Fix issue with not updating, when mouse not in area


func set_controllers(include_hex : bool = true):
	for tag in controllers:
		var ctrl = controllers[tag]
		if tag == "R":
			ctrl.set_value(red * 256.0)
		if tag == "G":
			ctrl.set_value(green * 256.0)
		if tag == "B":
			ctrl.set_value(blue * 256.0)
		
		if tag == "H":
			ctrl.set_value(hue * 256.0)
		if tag == "S":
			ctrl.set_value(saturation * 256.0)
		if tag == "V":
			ctrl.set_value(value * 256.0)
		
		# if ["H", "S", "V"].has(tag):
			# update_color_from_local_variables(COLOR_TYPE_UPDATE_TYPES.HSV)
		# if ["R", "G", "B"].has(tag):
			# update_color_from_local_variables(COLOR_TYPE_UPDATE_TYPES.RGB)
		
		if tag == "HEX" and include_hex:
			ctrl.set_color(color)
			ctrl.modulate = Color.WHITE
		
		
	# update() # Creates infinite loop


func _process(_delta):
	if not is_visible_in_tree():
		return
	# if not active:
	# 	return
	
	# update()
	get_drag_input()
	
	update_preview()

func _ready():
	make_hue_texture()
	set_input_type(0)
	
	connect_controllers()
	
	hue = color.h
	saturation = color.s
	value = color.v
	
	set_controllers()
	
	update()
	
	# Connect popup to closing
	INSTBUS.popup_manager.window_popped_up.connect(Callable(self, "hide_popup")) # self.connect(Callable(INSTBUS.popup_manager, 'window_popped_up'), 'hide_popup')

func hide_popup():
	hide()

func update_color_from_local_variables(update_type : COLOR_TYPE_UPDATE_TYPES, set_controller : bool = true):
	if update_type == COLOR_TYPE_UPDATE_TYPES.RGB:
		color.r = red
		color.g = green
		color.b = blue
		
		hue = color.h
		saturation = color.s
		value = color.v
	elif update_type == COLOR_TYPE_UPDATE_TYPES.HSV:
		color.h = hue
		color.s = saturation
		color.v = value
		
		red = color.r
		green = color.g
		blue = color.b
	else:
		hue = color.h
		saturation = color.s
		value = color.v
		
		red = color.r
		green = color.g
		blue = color.b
	
	# update_vs_drag()
	# update_h_drag()
	
	update()
	# print("Set controller from <update_color_from_local_variables>")
	if set_controller:
		set_controllers()
	
	update_preview()

func update():
	# update_color_from_local_variables(COLOR_TYPE_UPDATE_TYPES.HSV)
	# hue = color.h
	
	make_preview_texture()
	
	update_vs_drag()
	update_h_drag()
	
	# set_input_type()


func connect_controllers():
	for i in input_type_controller.get_children():
		for j in i.get_children():
			controllers[j.name] = j
			j.connect("value_submitted", Callable(self, "input_changed"))

func set_input_type(tab):
	for i in input_type_controller.get_children():
		i.hide()
	
	input_type_controller.get_child(tab).show() # old bug : Selecting one on switch

func update_preview():
	var panel = preview.get("theme_override_styles/panel") # bg_color
	panel.bg_color = color

func make_preview_texture():
	var img = Image.create(IMG_SIZE, IMG_SIZE, false, Image.FORMAT_BPTC_RGBA)
	img.decompress()
	# img.resize(IMG_SIZE, IMG_SIZE)
	for x in IMG_SIZE:
		for y in IMG_SIZE:
			var img_saturation = float(x) / float(IMG_SIZE)
			var img_value = float(y) / float(IMG_SIZE)
			img.set_pixel(x, y, Color.from_hsv(hue, img_saturation, 1.0 - img_value))
	
	var tex = ImageTexture.new()
	tex.set_image(img)
	color_preview_texture.texture = tex

func make_hue_texture():
	var img = Image.create(1, IMG_SIZE, false, Image.FORMAT_BPTC_RGBA)
	img.decompress()
	# img.resize(IMG_SIZE, IMG_SIZE)
	for y in IMG_SIZE:
		var hue = float(y) / float(IMG_SIZE)
		img.set_pixel(0, y, Color.from_hsv(hue, 1.0, 1.0))
	
	var tex = ImageTexture.new()
	tex.set_image(img)
	hue_preview_texture.texture = tex

var can_drag_preivew : bool = false
var can_drag_hue : bool = false

func get_drag_input():
	var mpos = get_global_mouse_position()
	
	# Value & Saturation
	var vs_from = color_preview_texture.global_position
	var vs_to = vs_from + color_preview_texture.size
	
	var in_vs = mpos == clamp2(mpos, vs_from, vs_to)
	if in_vs and Input.is_action_just_pressed("click"):
		can_drag_preivew = true
	if can_drag_preivew and Input.is_action_pressed("click"):
		mpos = clamp2(mpos, vs_from, vs_to)
		saturation = (mpos.x - vs_from.x) / (vs_to.x - vs_from.x)
		value = 1.0 - ((mpos.y - vs_from.y) / (vs_to.y - vs_from.y))
		# color = Color.from_hsv(color.h, s, v)
		# update_vs_drag()
		update_color_from_local_variables(COLOR_TYPE_UPDATE_TYPES.HSV, false)
		set_controllers()
		update()
	if Input.is_action_just_released("click") and can_drag_preivew:
		can_drag_preivew = false
	
	mpos = get_global_mouse_position()
	
	# Hue
	var h_from = hue_preview_texture.global_position
	var h_to = h_from + hue_preview_texture.size
	
	var in_h = mpos == clamp2(mpos, h_from, h_to)
	if in_h and Input.is_action_just_pressed("click"):
		can_drag_hue = true
	if can_drag_hue and Input.is_action_pressed("click"):
		mpos = clamp2(mpos, h_from, h_to)
		hue = (mpos.y - h_from.y) / (h_to.y - h_from.y)
		# color = Color.from_hsv(h, color.s, color.v)
		# update_h_drag()
		update_color_from_local_variables(COLOR_TYPE_UPDATE_TYPES.HSV, false)
		set_controllers()
		update()
	if Input.is_action_just_released("click") and can_drag_hue:
		can_drag_hue = false
	
	
	if (in_h or in_vs) and Input.is_action_pressed("click"):
		update_color_from_local_variables(COLOR_TYPE_UPDATE_TYPES.HSV)

func update_vs_drag():
	# var mpos = get_global_mouse_position()
	
	var vs_from = color_preview_texture.global_position
	var vs_to = vs_from + color_preview_texture.size
	
	color_preview_drag.global_position.x = lerpf(vs_from.x, vs_to.x, saturation) - 3
	color_preview_drag.global_position.y = lerpf(vs_from.y, vs_to.y, 1.0 - value) - 3

func update_h_drag():
	hue_preview_drag.position.y = hue * hue_preview_texture.size.y - 1

func clamp2(val : Vector2, from : Vector2, to : Vector2):
	var x = clampf(val.x, from.x, to.x)
	var y = clampf(val.y, from.y, to.y)
	return Vector2(x, y)


func _on_mouse_entered():
	active = true


func _on_mouse_exited():
	active = false
