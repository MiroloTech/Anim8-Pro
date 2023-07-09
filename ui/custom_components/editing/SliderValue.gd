extends Control
class_name DragController

var drag_start_pos : Vector2 = Vector2.ZERO
var dragging : bool = false
var drag_input : bool = false
var drag_diff : float = 0.0
var last_value : float = 0.0
var drag_dist : float = 0.0
var last_drag_dist : float = 0.0

var raw_value : float = 0.0
var focus : bool = false
var first_click_frame : bool = false

var text_edit : LineEdit = null

@export var value : float = 0.0
@export var drag_step : float = 0.05
@export var rounded : bool = false
@export var min : float = 0.0
@export var max : float = 100.0
@export var style : StyleBox = null
@export var prefix : String = ""
var mouse_in : bool = false
var is_mouse_entered : bool = false
var valid_drag : bool = false

func _input(event):
	if event is InputEventMouseMotion:
		if mouse_in and dragging:
			drag_dist = event.relative.x
			drag_diff += abs(event.relative.x)

func _ready():
	init()
	text_edit_text_submitted("")
	last_value = value

func init():
	text_edit = LineEdit.new()
	text_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_edit.set_anchors_preset(Control.PRESET_FULL_RECT)
	text_edit.set("theme_override_font_sizes/font_size", 12)
	var style_box_focus = StyleBoxFlat.new()
	style_box_focus.bg_color = Color(0, 0, 0, 0)
	text_edit.set("theme_override_styles/focus", style_box_focus)
	if style != null:
		text_edit.set("theme_override_styles/normal", style)
	# text_edit.update_minimum_size()
	# text_edit.custom_minimum_size = Vector2(20, 10)
	add_child(text_edit)
	
	text_edit.connect("text_changed", Callable(self, "text_edit_text_changed"))
	text_edit.connect("text_submitted", Callable(self, "text_edit_text_submitted"))
	text_edit.connect("mouse_entered", Callable(self, "mouse_entered"))
	text_edit.connect("mouse_exited", Callable(self, "mouse_exited"))
	text_edit.connect("focus_entered", Callable(self, "focus_entered"))
	text_edit.connect("focus_exited", Callable(self, "focus_exited"))

func _process(_delta):
	mouse_in = ((get_global_mouse_position() == clamp2(get_global_mouse_position(), global_position, global_position + size)) or dragging)
	if is_mouse_entered and valid_drag:
		mouse_in = true
	
	if not is_visible_in_tree():
		return
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if (mouse_in and dragging) else Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("click") and mouse_in:
		if is_mouse_entered:
			valid_drag = true
		
		first_click_frame = true
		text_edit.select_all_on_focus = false
		drag_dist = 0.0
		dragging = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		text_edit_text_submitted("")
		emit_signal("value_submitted", value, name)
	
	if Input.is_action_just_released("click") and dragging:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		dragging = false
		drag_dist = 0.0
		get_viewport().warp_mouse(global_position + (size / 2)) # Not warping mouse if dragging to fast
		if drag_diff < 5.0: # Pressed
			text_edit.text = str(value)
			text_edit.select_all_on_focus = true
			text_edit.grab_focus()
		drag_diff = 0.0
		valid_drag = false
	
	# Check, if mouse not moving
	if last_drag_dist == drag_dist:
		drag_dist = 0.0
	
	if Input.is_action_pressed("click") and mouse_in and valid_drag:
		text_edit_text_submitted("")
		emit_signal("value_submitted", value, name)
		
		if not first_click_frame:
			set_value_from_raw()
			
		first_click_frame = false
	else:
		drag_dist = 0.0
	
	last_drag_dist = drag_dist

func set_value_from_raw():
	raw_value += drag_dist * drag_step
	raw_value = clampf(raw_value, min, max)
	value = ( floor(raw_value / drag_step) * drag_step ) if !rounded else floor(raw_value)

func text_edit_text_changed(new_text):
	var val = str_to_var(new_text)
	if val != null:
		value = val
		value = clampf(value, min, max)

func focus_entered():
	focus = true

func focus_exited():
	focus = false

func text_edit_text_submitted(new_text, emit : bool = true):
	text_edit.release_focus()
	text_edit.text = str(value) if focus else prefix + str(value)
	
	if last_value != value:
		last_value = value
		if emit:
			emit_signal("value_submitted", value, name)

func mouse_entered():
	is_mouse_entered = true

func mouse_exited():
	is_mouse_entered = false

func clamp2(val : Vector2, from : Vector2, to : Vector2):
	var x = clampf(val.x, from.x, to.x)
	var y = clampf(val.y, from.y, to.y)
	return Vector2(x, y)

func set_value(val : float):
	raw_value = val
	raw_value = clampf(raw_value, min, max)
	if not rounded:
		raw_value = roundf(raw_value / drag_step) * drag_step
	else:
		raw_value = floor(raw_value)
	set_value_from_raw()
	text_edit_text_submitted("", false)




signal value_submitted(new_value, tag)
