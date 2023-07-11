extends Node

var layers : Array[AnimLayer] = []

func add_layer():
	pass # Add UI for new Layer, and add Layer to list

func move_layer(layer : AnimLayer, to : int):
	pass # Change position valriable in class to 'to'

func delete_layer(layer : AnimLayer):
	pass # Remove ui and element from list

func animate_component(value : Value):
	pass # Create AnimKeyLayer and first key frame
