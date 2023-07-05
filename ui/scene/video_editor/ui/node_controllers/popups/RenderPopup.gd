extends Control

@onready var type_menu = $Panel/MarginContainer/Content/Body/TypeMenu
@onready var scale_menu = $Panel/MarginContainer/Content/Body/ScaleMenu
@onready var fps_menu = $Panel/MarginContainer/Content/Body/FrameRateMenu
@onready var aspect_menu = $Panel/MarginContainer/Content/Body/AspecMenu

@onready var ffmpeg_warning = $Panel/MarginContainer/Content/Final/Warnings/ffmpeg
@onready var upscaling_info = $Panel/MarginContainer/Content/Final/Warnings/Upscaling
@onready var render_btn = $Panel/MarginContainer/Content/Final/RenderBtn
@onready var render_btn_progress = $Panel/MarginContainer/Content/Final/RenderBtn/ProgressBar

var can_render : bool = false

var render_type : String = ".mp4"
var upscaling : float = 1.0
var fps : int = 60
var aspect_ratio : String = "16 : 9"

var render_pressed : bool = false
var render_loading_progress : float = 0.0

const RENDER_LOADING_SPEED = 100.0

# Displays selections of menus
func set_menu_display():
	type_menu.text = render_type
	scale_menu.text = str(upscaling) + "x"
	fps_menu.text = str(fps) + " fps"
	aspect_menu.text = aspect_ratio

# Sets settings for rendering from UI
func set_render_settings():
	if Input.is_action_just_pressed("click"):
		# Set File Type
		if type_menu.get_popup().visible:
			var type_result = get_selected_menu_item(type_menu.get_popup())
			render_type = type_result if type_result != null else render_type
		
		# Set Upscale size
		if scale_menu.get_popup().visible:
			var scale_result_str = get_selected_menu_item(scale_menu.get_popup())
			if scale_result_str == null: return
			var scale_result : float = str_to_var(scale_result_str.replace('x', ''))
			upscaling = scale_result if scale_result != null else upscaling
		
		# Set FPS
		if fps_menu.get_popup().visible:
			var fps_result_str = get_selected_menu_item(fps_menu.get_popup())
			if fps_result_str == null: return
			var fps_result : int = str_to_var(fps_result_str.replace(' fps', ''))
			fps = fps_result if fps_result != null else fps
		
		# Set Aspect
		if aspect_menu.get_popup().visible:
			var aspect_result = get_selected_menu_item(aspect_menu.get_popup())
			if aspect_result == null: return
			aspect_ratio = aspect_result if aspect_result != null else aspect_ratio

# Shows appropriate warnings, based on situation
func show_warnings():
	upscaling_info.visible = upscaling > 1.0
	ffmpeg_warning.visible = not ['.png', '.jpg'].has(render_type)

# Runs every frame
func _process(delta):
	show_warnings()
	set_render_settings()
	set_menu_display()
	slow_down_render_button(delta)


# Returns text of selected menu item
func get_selected_menu_item(menu : PopupMenu):
	# Define base variables
	# var mpos = get_global_mouse_position()
	var focus_id = menu.get_focused_item()
	
	# Check if Selection is valid
	if focus_id != -1:
		# # Check if mouse is in bounds
		# if (mpos > global_position + Vector2(menu.position)) and (mpos < global_position + Vector2(menu.position + menu.size)):
		# Return item name
		return menu.get_item_text(focus_id)
	
	return null


# Runs when popup exit button is pressed
func _on_exit_pressed():
	hide()

func slow_down_render_button(delta : float):
	if render_btn.button_pressed and not render_pressed:
		render_loading_progress += delta * RENDER_LOADING_SPEED
	else:
		render_loading_progress -= delta * 3.5 * RENDER_LOADING_SPEED
	
	render_loading_progress = clampf(render_loading_progress, 0.0, 100.0)
	render_btn_progress.value = render_loading_progress
	
	if render_loading_progress <= 0.0:
		render_pressed = false
	
	if render_loading_progress >= 100.0:
		# render_loading_progress = 0
		if not render_btn.button_pressed:
			render_pressed = true

func render():
	print("Render")
