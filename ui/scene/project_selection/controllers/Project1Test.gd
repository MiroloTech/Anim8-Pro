extends Control

@onready var click_progress = $ProgressBar
@onready var button = $MarginContainer/Button
@onready var delete_button = $MarginContainer/Content/ButtonContainer/Delete

var loading_speed = 350.0
var deletion_speed = 100.0

func _process(delta):
	var ls = loading_speed * delta
	var ds = deletion_speed * delta
	click_progress.modulate = Color.WHITE
	
	if button.button_pressed:
		click_progress.value += ls
		
		if click_progress.value > 95:
			print("Project <" + str(name) + "> opened")
	
	elif delete_button.button_pressed:
		click_progress.value += ds
		
		if click_progress.value > 95:
			print("Project <" + str(name) + "> deleted")
		click_progress.modulate = Color(1.0, 0.9, 0.95)
	
	else:
		click_progress.value -= ls * 2
		
		click_progress.modulate = Color.WHITE

