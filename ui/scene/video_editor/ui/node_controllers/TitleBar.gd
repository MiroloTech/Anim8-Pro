extends Panel

@onready var project_title = $MarginContainer/Centre/ProjectTitle

func _on_render_btn_pressed():
	INSTBUS.popup_manager.show_popup('render popup')

func _process(_delta):
	# set title to project name
	if PROJECTINFO.settings["name"] != null:
		project_title.text = PROJECTINFO.settings["name"]
