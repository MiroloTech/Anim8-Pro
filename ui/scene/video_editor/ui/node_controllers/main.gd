extends Control


# Runs once at start
func _ready():
	# load .json project file
	PROJECTINFO.load_project("res://classes/global/project/pjinfo-video_test.json")

# Runs every frame
func _process(_delta):
	# Listen for input
	if Input.is_action_just_pressed("screenshot"):
		make_screenshot()

# Take screenshot of app
func make_screenshot():
	var image = get_viewport().get_texture().get_image()
	image.save_png("res://screenshots/screenshot-" + str(randi() % 999) + ".png")
	print("screenshot taken")

