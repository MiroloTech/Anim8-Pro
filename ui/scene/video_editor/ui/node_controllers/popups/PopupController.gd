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
func _process(_delta):
	show_bg()
	manage_popup_queue()

var popup_queue : Array[String] = []

# Returns the node that would be popped up
func find_popup(tag : String) -> Node:
	if popup_container == null: return null
	
	var closest_popup = popup_container.get_child(0)
	
	if closest_popup == null: return null
	
	var closest_score : float = 0.0
	for c in popup_container.get_children():
		var score = c.name.similarity(tag)
		if score > closest_score:
			closest_score = score
			closest_popup = c
	
	if closest_score < 0.1:
		return null
	
	return closest_popup

func manage_popup_queue():
	for p in popup_queue:
		var popup = find_popup(p)
		if popup == null: continue
		
		show_popup(p)

# Shows popup as soons as avalable
func queue_popup(tag : String):
	var popup = find_popup(tag)
	if popup == null:
		popup_queue.append(tag)
	else:
		show_popup(tag)



# Gets called, when a popups needs to be displaied
func show_popup(tag : String):
	# TODO : use util function : get_most_simmilar()
	# Find popup based on tag
	var popup = find_popup(tag)
	if popup == null : return
	
	popup.show()
	
	emit_signal("window_popped_up")
