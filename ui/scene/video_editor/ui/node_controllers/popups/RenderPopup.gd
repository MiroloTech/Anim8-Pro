extends Control

@onready var type_menu = $Panel/MarginContainer/Content/Body/TypeMenu
@onready var resolution_menu = $Panel/MarginContainer/Content/Body/ResolutionMenu
@onready var scale_menu = $Panel/MarginContainer/Content/Body/ScaleMenu
@onready var fps_menu = $Panel/MarginContainer/Content/Body/FrameRateMenu
@onready var aspect_menu = $Panel/MarginContainer/Content/Body/AspectMenu

@onready var ffmpeg_warning = $Panel/MarginContainer/Content/Final/Warnings/ffmpeg
@onready var upscaling_info = $Panel/MarginContainer/Content/Final/Warnings/Upscaling
@onready var render_btn = $Panel/MarginContainer/Content/Final/RenderBtn
@onready var render_btn_progress = $Panel/MarginContainer/Content/Final/RenderBtn/ProgressBar

@onready var stats_label = $Panel/MarginContainer/Content/Final/Statistics/RichTextLabel

var can_render : bool = false

var render_type : String = ".mp4"
var resolution : String = "1080p"
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
	resolution_menu.text = resolution

# Sets settings for rendering from UI
func set_render_settings():
	if Input.is_action_just_pressed("click"):
		# Set File Type
		if type_menu.get_popup().visible:
			var type_result = get_selected_menu_item(type_menu.get_popup())
			render_type = type_result if type_result != null else render_type
			PROJECTINFO.settings["file_type"] = render_type
		
		if resolution_menu.get_popup().visible:
			var resolution_result = get_selected_menu_item(resolution_menu.get_popup())
			if resolution_result == null: return
			resolution = resolution_result if resolution_result != null else resolution
			PROJECTINFO.settings["resolution"] = render_type
		
		# Set Upscale size
		if scale_menu.get_popup().visible:
			var scale_result_str = get_selected_menu_item(scale_menu.get_popup())
			if scale_result_str == null: return
			var scale_result : float = str_to_var(scale_result_str.replace('x', ''))
			upscaling = scale_result if scale_result != null else upscaling
			PROJECTINFO.settings["upscaling"] = upscaling
		
		# Set FPS
		if fps_menu.get_popup().visible:
			var fps_result_str = get_selected_menu_item(fps_menu.get_popup())
			if fps_result_str == null: return
			var fps_result : int = str_to_var(fps_result_str.replace(' fps', ''))
			fps = fps_result if fps_result != null else fps
			PROJECTINFO.settings["fps"] = fps
		
		# Set Aspect
		if aspect_menu.get_popup().visible:
			var aspect_result = get_selected_menu_item(aspect_menu.get_popup())
			if aspect_result == null: return
			aspect_ratio = aspect_result if aspect_result != null else aspect_ratio
			PROJECTINFO.settings["aspect_ratio"] = aspect_ratio

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
	
	set_stats()


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

var aspect_sizes = {
	"16K"    : 15360.0 / 16.0,      # 15360.0 / 8640.0,
	"8K"     : 7680.0  / 16.0,      # 7680.0 / 4320.0,
	"6K"     : 6400.0  / 16.0,      # 6400.0 / 3600.0,
	"5K"     : 5120.0  / 16.0,      # 5120.0 / 2880.0,
	"4K"     : 3840.0  / 16.0,      # 3840.0 / 2160.0,
	"2K"     : 2560.0  / 16.0,      # 2560.0 / 1440.0,
	"1080p"  : 1920.0  / 16.0,      # 1920.0 / 1080.0,
	"720p"   : 1280.0  / 16.0,      # 1280.0 / 720.0,
	"480p"   : 640.0   / 16.0,      # 640.0 / 480.0,
	"360p"   : 480.0   / 16.0,      # 480.0 / 360.0,
	"240p"   : 426.0   / 16.0,      # 426.0 / 240.0,
	"144p"   : 256.0   / 16.0,      # 256.0 / 144.0
}

func set_stats():
	# name
	var file_name = PROJECTINFO.settings["name"] + render_type
	
	# resolution
	var multiplikator = aspect_sizes[resolution]
	var aspect_txt_split = aspect_ratio.split(" : ")
	var total_resolution = Vector2(str_to_var(aspect_txt_split[0]), str_to_var(aspect_txt_split[1])) * multiplikator * upscaling
	
	# file size
	var frame_count = PROJECTINFO.settings["frame_count"]
	var file_size = guess_size(frame_count, total_resolution, fps, render_type)
	var file_size_str : String = format_bytes(file_size) # Add conversion to kb, mb, gb, tb, etc
	
	# set
	stats_label.text = "	file size             : %s
	name                 : %s
	resolution       : %s" % [file_size_str, file_name, str(str(total_resolution.x) + " x " + str(total_resolution.y))]

func guess_size(frame_count: int, res: Vector2, fps: int, file_type: String) -> int:
	var total_pixels = res.x * res.y
	var bits_per_pixel = 0
	
	# Calculate bits per pixel based on file type
	match file_type:
		".mp4", ".avi", ".mpg", ".mov", ".ogv", ".mkv":
			bits_per_pixel = 24  # Assuming 24-bit color depth for video formats
		
		".png":
			bits_per_pixel = 32  # Assuming 32-bit color depth for PNG image sequences
		
		".jpg":
			bits_per_pixel = 24  # Assuming 24-bit color depth for JPEG image sequences
		
		_:
			print("Unsupported file type:", file_type)
			return 0
	
	# Calculate estimated file size in bytes
	var bits_per_frame = total_pixels * bits_per_pixel
	var bytes_per_frame = bits_per_frame / 8
	var total_bytes = bytes_per_frame * frame_count
	
	# Adjust file size based on frame rate
	var total_time = frame_count * fps
	total_bytes *= total_time
	
	return int(total_bytes)

func format_bytes(byte_count: int, after_digits : int = 2) -> String:
	var units = ["b", "kb", "mb", "gb", "tb", "pb", "eb"]
	var unit_index = 0
	var bytes = byte_count
	
	while bytes >= 1024 and unit_index < units.size() - 1:
		bytes /= 1024.0
		unit_index += 1
	
	var digit_rounding = pow(10, after_digits)
	bytes = roundf(bytes * digit_rounding) / digit_rounding
	return str(bytes) + " " + units[unit_index]
