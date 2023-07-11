extends Node

func lerpv(a, b, x : float, is_angle : bool = false):
	if typeof(a) != typeof(b): print("Can't lerp values of different types : " + str(typeof(a)) + " and " + str(typeof(b))); return null
	
	var type = typeof(a)
	
	if type == TYPE_FLOAT:
		return lerp_angle_descider(a, b, x, is_angle)
	if type == TYPE_INT:
		return round(lerp_angle_descider(a, b, x, is_angle))
	if type == TYPE_STRING:
		return lerp_string(a, b, x)
	if type == TYPE_BOOL:
		return bool(round(lerp(int(a), int(b), x)))
	if type == TYPE_VECTOR2:
		return Vector2(lerpf(a.x, b.x, x), lerpf(a.y, b.y, x))
	if type == TYPE_VECTOR2I:
		return Vector2i(round(lerpf(a.x, b.x, x)), round(lerpf(a.y, b.y, x)))
	if type == TYPE_VECTOR3:
		return Vector3(lerpf(a.x, b.x, x), lerpf(a.y, b.y, x), lerpf(a.z, b.z, x))
	if type == TYPE_VECTOR3I:
		return Vector3i(round(lerpf(a.x, b.x, x)), round(lerpf(a.y, b.y, x)), round(lerpf(a.z, b.z, x)))
	if type == TYPE_VECTOR3I:
		return Color(lerpf(a.r, b.r, x), lerpf(a.g, b.g, x), lerpf(a.b, b.b, x), lerpf(a.a, b.a, x))

func lerp_angle_descider(a, b, x : float, is_angle : bool):
	if is_angle:
		return lerp_angle(a, b, x)
	return lerpf(a, b, x)

func lerp_string(from : String, to : String, weight : float) -> String:
	# get lengths
	var lenA = from.length()
	var lenB = to.length()
	var len = max(lenA, lenB)
	
	var a = from
	var b = to
	
	# set both to same length
	for _x in len - lenA:
		a += " "
	for _x in len - lenB:
		b += " "
	
	# interpolate
	var char_count_a = round(float(len) * weight)
	var final = ""
	
	for l in len:
		if l < char_count_a:
			final += a[l]
		else:
			final += b[l]
	
	return final
