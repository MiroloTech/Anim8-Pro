extends Node2D

var preview : Array[float] = []

func _ready():
	var aa = AnimAudio.new()
	aa.load_file("res://test/audio/mixkit-funny-cartoon-fast-splat-2889.wav")
	preview = aa.get_waveform_preview(AnimAudio.WAVEFORM_DETAIL.HIGH)
	
	queue_redraw()

func _draw():
	var perc = 0.0
	var last_h = 0.0
	var last_x = 0.0
	for pid in range(0, preview.size()):
		var p = preview[pid]
		var total_height = 200
		var width = 400 * 0.005
		var h = round(p * total_height / 1.0) * 1.0
		var x = pid * width
		draw_line(Vector2(last_x, last_h), Vector2(x, h), Color.CHARTREUSE, 3.0)
		# draw_colored_polygon([Vector2(last_x, -last_h), Vector2(x, -h), Vector2(x, 0), Vector2(last_x, 0)], Color.CHARTREUSE)
		last_h = h
		last_x = x
	
	draw_line(Vector2(0, 0), Vector2(last_x, 0), Color.DARK_GRAY, 2.0)
