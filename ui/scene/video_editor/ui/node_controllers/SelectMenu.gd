extends HBoxContainer

@onready var menu_controller = $MenuContainer
@onready var menu_containter = $InspectorPanels

var selected_menu = null

func _process(delta):
	var select_id = menu_controller.target_btn_id
	for c in menu_containter.get_children():
		if c != selected_menu:
			c.modulate.a = lerpf(c.modulate.a, 0.0, delta * 20.0)
		else:
			c.modulate.a = lerpf(c.modulate.a, 1.0, delta * 20.0)
			c.show()
		
		if c.modulate.a < 0.05:
			c.hide()
	
	selected_menu = menu_containter.get_child(select_id)
