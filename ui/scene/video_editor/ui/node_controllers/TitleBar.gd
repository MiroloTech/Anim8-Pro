extends Panel


func _on_render_btn_pressed():
	INSTBUS.popup_manager.show_popup('render popup')
