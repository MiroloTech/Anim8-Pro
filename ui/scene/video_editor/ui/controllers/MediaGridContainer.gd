extends GridContainer

@export var media_size = 50

func _process(_delta):
	var coll : int = floor(size.x / (media_size + get_theme_constant("h_separation")))
	columns = coll
