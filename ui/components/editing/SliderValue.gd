extends Control
class_name DragController

var drag_start_pos : Vector2 = Vector2.ZERO
var dragging : bool = false
var drag_input : bool = false
var drag_diff : float = 0.0

var text_edit : LineEdit = null

@export var value : float = 0.0
@export var drag_step : float = 0.05
@export var rounded : bool = true
@export var min : float = 0.0
@export var max : float = 100.0
@export var style : StyleBox = null
var mouse_in : bool = false

func _input(event):
	if event is InputEventMouseMotion:
		if mouse_in and dragging:
			var add = event.relative.x * drag_step
			var fin = round(add) if rounded else add
			value += fin
			drag_diff += abs(event.relative.x)

func _ready():
	init()
	text_edit_text_submitted("")

func init():
	text_edit = LineEdit.new()
	text_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_edit.set_anchors_preset(Control.PRESET_FULL_RECT)
	text_edit.set("theme_override_font_sizes/font_size", 12)
	add_child(text_edit)
	
	text_edit.connect("text_changed", Callable(self, "text_edit_text_changed"))
	text_edit.connect("text_submitted", Callable(self, "text_edit_text_submitted"))
	text_edit.position = Vector2.ZERO

func _process(_delta):
	mouse_in = (get_global_mouse_position() == clamp2(get_global_mouse_position(), global_position, global_position + size)) or dragging
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if (mouse_in and dragging) else Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("click") and mouse_in:
		text_edit.select_all_on_focus = false
		dragging = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_released("click") and dragging:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		dragging = false
		get_viewport().warp_mouse(global_position + (size / 2))
		if drag_diff < 5.0:
			text_edit.select_all_on_focus = true
			text_edit.grab_focus()
		drag_diff = 0.0
	
	if Input.is_action_pressed("click") and mouse_in:
		text_edit_text_submitted("")


func text_edit_text_changed(new_text):
	var val = str_to_var(new_text)
	if val != null:
		value = val

func text_edit_text_submitted(_new_text):
	text_edit.text = str(value)
	text_edit.release_focus()


func clamp2(val : Vector2, from : Vector2, to : Vector2):
	var x = clampf(val.x, from.x, to.x)
	var y = clampf(val.y, from.y, to.y)
	return Vector2(x, y)


