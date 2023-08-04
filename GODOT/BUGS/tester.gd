extends Node

func test(a : String, b : String):
	return a + b

func _ready():
	var methods = self.get_method_list()
	for m in methods:
		if m.name == 'test':
			var args = m.args
			print(args)
			
			"""
			should return:
				{ "name": "a", "class_name": "Node", "type" : 4, "hint": .....,
				  "name": "b", "class_name": "Node", "type" : 4, "hint": .....,
				}
			"""
