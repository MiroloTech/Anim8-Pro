extends Node
class_name Value

var value = null
var tag : String = "unnamed"
var min = null
var max = null

var controller = null

func _init(value, min = null, max = null):
	if verify_type(value): print("Tried to instantiate Value class with invalid type : " + str(typeof(value))); return
	self.value = value
	self.min = min
	self.max = max
	
	controller = MAKEUI.create_controller(typeof(value))
	MAKEUI.connect_controller_to_value_changed(controller_update, Callable(self, "controller_update"))


static func verify_type(val) -> bool:
	return MAKEUI.valid_types.has(typeof(val))

func is_same_type(val) -> bool:
	return typeof(value) == typeof(val)

func set_value(setter):
	if not is_same_type(setter): print("Tried to change value " + tag + " type from " + str(typeof(value)) + " to " + str(typeof(setter))); return
	
	value = setter
	update()

func get_value():
	return value

func controller_update():
	var new_value = MAKEUI.get_controller_value(controller)
	if not is_same_type(new_value): print("Tried to change value " + tag + " type from " + str(typeof(value)) + " to " + str(typeof(new_value))); return
	value = new_value

func update():
	if [TYPE_INT, TYPE_FLOAT].has(typeof(value)):
		value = max(value, min) if ([TYPE_INT, TYPE_FLOAT].has(typeof(min)) and min != null) else value
		value = min(value, max) if ([TYPE_INT, TYPE_FLOAT].has(typeof(max)) and max != null) else value
	
	MAKEUI.set_controller_value(controller, value)
