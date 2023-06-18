extends MenuButton

var submenu = PopupMenu.new()
func _ready():
	var p = get_popup()
	
	submenu.set_name("exports")
	submenu.add_icon_item(preload("res://ui/scene/video_editor/ui/icons/menu/mode-landscape.png"), "Current Frame")
	submenu.add_icon_item(preload("res://ui/scene/video_editor/ui/icons/menu/time-quarter-past.png"), "Clip")
	
	p.add_child(submenu)
	p.add_submenu_item("Export", "exports", 99)
