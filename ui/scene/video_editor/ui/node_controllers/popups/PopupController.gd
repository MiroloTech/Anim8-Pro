extends Control

@onready var popup_container = $Popups
@onready var darkener = $BG

signal window_popped_up()

# Runs at start of program
func _enter_tree():
	INSTBUS.popup_manager = self
	show()

# Shows Darkening Panel only when one or more popups are visible
func show_bg():
	for p in popup_container.get_children():
		if p.visible:
			darkener.show()
			return
	
	darkener.hide()


# Runs every frame
func _process(_darkenerdelta):
	show_bg()

# Gets called, when a popups needs to be displaied
func show_popup(tag : String):
	# TODO : use util function : get_most_simmilar()
	# Find popup based on tag
	var closest_popup = popup_container.get_child(0)
	var closest_score : float = 0.0
	for c in popup_container.get_children():
		var score = c.name.similarity(tag)
		if score > closest_score:
			closest_score = score
			closest_popup = c
	
	if closest_score < 0.1:
		return
	
	closest_popup.show()
	
	emit_signal("window_popped_up")
