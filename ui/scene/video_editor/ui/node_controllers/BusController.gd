extends Panel

@onready var limit_slider = $MarginContainer/Contents/AudioPreview/VolumeLimiter
@onready var audio_label = $MarginContainer/Contents/Label

func _process(_delta):
	var prefix = "+"
	if limit_slider.value < 0: prefix = ""
	
	audio_label.text = prefix + str(limit_slider.value)
