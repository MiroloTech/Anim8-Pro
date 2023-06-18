extends Node
class_name AnimEffectBase

# Busses : 
# Amplify      -> Boosts Audio Volume
# Chorus       -> I dont know what this does
# Compress     -> Compresses Audio to lower quality
# EQ           -> Cuts out x% of selected frequence
# Filter       -> Cuts out certain frequencies
# Limit        -> Limits Audio Volume
# ! Pan        -> Shifts Audio Left - Right Ratio
# Phaser       -> Shifts Pitch by Wave
# Pitch Shift  -> Shifts pitch
# Reverb       -> Adds audio bounce-backs
# Tune         -> Tunes Audio to base set of notes ( pitches )

var tag : String = ""

func _run(stream : AudioStream) -> AudioStream:
	return stream
