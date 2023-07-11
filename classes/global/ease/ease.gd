extends Node
# This implements different easing functions for global use
# Data from : https://easings.net

const c1 = 1.70158;
const c2 = c1 * 1.525;
const c3 = c1 + 1;
const c4 = (2 * PI) / 3;
const c5 = (2 * PI) / 4.5;

const n1 = 7.5625;
const d1 = 2.75;

enum EASE_DIR {
	IN,
	OUT,
	INOUT
}

enum EASE_TYPE {
	SINE,
	QUAD,
	CUBIC,
	QUART,
	QUINT,
	EXPO,
	CIRC,
	BACK,
	ELASTIC,
	BOUNCE
}

func bias(x : float, bias : float):
	var k = pow(1 - bias, 3)
	return (x * k) / (x * k - x + 1)

func ease(x : float, type : EASE_TYPE, dir : EASE_DIR):
	match type:
		EASE_TYPE.SINE:
			match dir:
				EASE_DIR.IN:
					return 1 - cos((x * PI) / 2)
				EASE_DIR.OUT:
					return sin((x * PI) / 2)
				EASE_DIR.INOUT:
					return -(cos(x * PI) - 1) / 2
		EASE_TYPE.QUAD:
			match dir:
				EASE_DIR.IN:
					return x * x
				EASE_DIR.OUT:
					return 1 - (1 - x) * (1 - x)
				EASE_DIR.INOUT:
					return 2 * x * x if x < 0.5 else 1.0 - pow(-2.0 * x + 2, 2) / 2
		EASE_TYPE.CUBIC:
			match dir:
				EASE_DIR.IN:
					return x * x * x
				EASE_DIR.OUT:
					return 1 - pow(1 - x, 3)
				EASE_DIR.INOUT:
					return 4 * x * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 3) / 2
		EASE_TYPE.QUART:
			match dir:
				EASE_DIR.IN:
					return x * x * x * x
				EASE_DIR.OUT:
					return 1 - pow(1 - x, 4)
				EASE_DIR.INOUT:
					return 8 * x * x * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 4) / 2
		EASE_TYPE.QUINT:
			match dir:
				EASE_DIR.IN:
					return x * x * x * x * x
				EASE_DIR.OUT:
					return 1 - pow(1 - x, 5)
				EASE_DIR.INOUT:
					return 16 * x * x * x * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 5) / 2
		EASE_TYPE.EXPO:
			match dir:
				EASE_DIR.IN:
					return 0 if x == 0 else pow(2, 10 * x - 10)
				EASE_DIR.OUT:
					return 1 if x == 1 else 1 - pow(2, -10 * x)
				EASE_DIR.INOUT:
					return 0 if x == 0 else (1 if x == 1 else (pow(2, 20 * x - 10) / 2 if x < 0.5 else (2 - pow(2, -20 * x + 10)) / 2))
		EASE_TYPE.CIRC:
			match dir:
				EASE_DIR.IN:
					return 1 - sqrt(1 - pow(x, 2))
				EASE_DIR.OUT:
					return sqrt(1 - pow(x - 1, 2))
				EASE_DIR.INOUT:
					return (1 - sqrt(1 - pow(2 * x, 2))) / 2 if x < 0.5 else (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2
		EASE_TYPE.BACK:
			match dir:
				EASE_DIR.IN:
					return c3 * x * x * x - c1 * x * x
				EASE_DIR.OUT:
					return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2)
				EASE_DIR.INOUT:
					return (pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2 if x < 0.5 else (pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2
		EASE_TYPE.ELASTIC:
			match dir:
				EASE_DIR.IN:
					return 0 if x == 0 else (1 if x == 1 else -pow(2, 10 * x - 10) * sin((x * 10 - 10.75) * c4))
				EASE_DIR.OUT:
					return 0 if x == 0 else (1 if x == 1 else  pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1)
				EASE_DIR.INOUT:
					return 0 if x == 0 else (1 if x == 1 else (-(pow(2, 20 * x - 10) * sin((20 * x - 11.125) * c5)) / 2 if x < 0.5 else (pow(2, -20 * x + 10) * sin((20 * x - 11.125) * c5)) / 2 + 1))
		EASE_TYPE.BOUNCE:
			match dir:
				EASE_DIR.IN:
					return 1 - ease_bounce(1 - x)
				EASE_DIR.OUT:
					return ease_bounce(x)
				EASE_DIR.INOUT:
					return (1 - ease_bounce(1 - 2 * x) / 2) if x < 0.5 else (1 + ease_bounce(2 * x - 1)) / 2
	
	return -1.0

func ease_bounce(x : float) :
	if (x < 1 / d1):
		return n1 * x * x
	elif (x < 2 / d1):
		return n1 * ((x - 1.5) / d1) * (x - 1.5) + 0.75
	elif (x < 2.5 / d1):
		return n1 * ((x - 2.25) / d1) * (x - 2.25) + 0.9375
	else:
		return n1 * ((x - 2.625) / d1) * (x - 2.625) + 0.984375

