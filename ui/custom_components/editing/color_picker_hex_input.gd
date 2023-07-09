extends LineEdit

var color : Color = Color.RED

func _on_text_changed(new_text):
	var err = Color(0, 0, 0, 0)
	var col = Color.from_string(new_text, err)
	
	modulate = Color.WHITE
	
	if col != err:
		color = col
		# print("UPDATEEEE")
		# print(color)
		emit_signal("value_submitted", color, name)
		return # Succesfull
	
	var error_color = Color('eea49f')
	modulate = error_color
	# Error

func set_color(new_color : Color):
	color = new_color
	var show_alpha = new_color.a != 1.0
	text = "#" + str(new_color.to_html(show_alpha))
	caret_column = text.length()


#func _on_text_submitted(new_text):
#	var err = _on_text_changed(new_text)
#	if not err:
#		emit_signal("value_submitted", color, name)
#		# print("hex value set")


signal value_submitted(new_value, tag)

