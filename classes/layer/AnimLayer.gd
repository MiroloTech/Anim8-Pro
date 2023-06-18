extends Node
class_name AnimLayer

# all layer lypes
enum LAYER_TYPE {
	VIDEO,      # Video ( Collage of Frames )
	IMAGE,      # Static Image
	EFFECT,     # Overlay Effect ( Shader )
	SHAPE,      # Text, Curve, etc.
	
	ANIMATION,  # Keyframe flow
}

# global variables
var UID : int = 0
var id : String = "0"
var type : LAYER_TYPE
var tag : String = "unnamed"
var children : Array[AnimLayer] = []
var is_ready : bool = false
var start_pos : float = 0.0
var length : float = 0.0

