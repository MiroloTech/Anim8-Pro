extends GridContainer

@export var media_size = 80
@export var panel_style : StyleBox = null

var added_paths : Array[String] = []

func _process(_delta):
	var coll : int = floor(size.x / (media_size + get_theme_constant("h_separation")))
	columns = coll

func update_preview():
	if PROJECTINFO.settings.is_empty(): PROJECTINFO.load_project(GLOBAL.project_path)
	for path in PROJECTINFO.settings["resources"]:
		if added_paths.has(path): continue
		
		# path is .frames folder
		var file_name = path.rsplit("/", true, 1)[1]
		file_name = file_name.rsplit(".", true, 1)[0]
		
		var dir : DirAccess = DirAccess.open(path)
		if not dir: print("Error with final path while creating preview... : " + path); return
		
		dir.list_dir_begin()
		var fn = dir.get_next()
		if fn == "": print("ERROR : Tried to create a preview for an empty video..."); return
		
		var texture = ImageTexture.new()
		var img = Image.load_from_file(path + "/" + fn)
		texture.set_image(img)
		
		var panel = Panel.new()
		panel.set("theme_override_styles/panel", panel_style)
		panel.custom_minimum_size = Vector2(media_size, media_size)
		
		var vbox = VBoxContainer.new()
		vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
		panel.add_child(vbox)
		
		var preview = TextureRect.new()
		preview.size_flags_vertical = Control.SIZE_EXPAND_FILL
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		preview.texture = texture
		vbox.add_child(preview)
		
		var tag = Label.new()
		tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		tag.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		tag.clip_text = true
		tag.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS
		tag.text = file_name
		tag.set("theme_override_font_sizes/font_size", 12)
		vbox.add_child(tag)
		
		add_child(panel)
		
		added_paths.append(path)
