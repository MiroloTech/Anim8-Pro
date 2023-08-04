extends AnimLayer
class_name AnimKeyLayer

var keys : Array[Keyframe] = []
var value : Value = null

func add_key(time : float, new_value : float):
	var key = Keyframe.new()
	key.value = new_value
	key.time = time
	key.create_ui_elemnt()
	sort_keys()

func sort_keys():
	keys.sort_custom(func(a, b): return a.time < b.time)

func interpolate(time : float):
	for kid in keys.size() - 1:
		var keyA = keys[kid]
		var keyB = keys[kid + 1]
		
		var in_time = time == clampf(time, keyA.time, keyB.time)
		
		if not in_time: continue
		
		# TODO : add keyframe interpolation modes EASING, LINEAR, INSTANT
		var range = (time - keyA.time) / (keyB.time - keyA.time)
		var eased_range = EASE.bias(range, keyA.easing)
		var raw = VARUTIL.lerpv(keyA.value, keyB.value, eased_range)
		value.set_value(raw)
