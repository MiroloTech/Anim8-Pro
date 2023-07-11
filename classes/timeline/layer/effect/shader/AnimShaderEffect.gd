extends Node

var shader : Shader

var is_ready : bool = false

func get_uniforms_as_ui() -> Array:
	var uiarr = []
	
	for uniform in shader.get_shader_uniform_list():
		var label = uniform.name
		var controller = MAKEUI.create_controller(uniform.type)
		uiarr.append([label, controller])
	
	return uiarr


