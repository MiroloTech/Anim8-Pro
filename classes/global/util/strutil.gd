extends Node

# Returns the most simmilar string in list
func get_most_simmilar(prompt : String, list : Array[String]):
	if list.is_empty():
		return
	
	var closest_str = list[0]
	var closest_score : float = 0.0
	for s in list:
		var score = s.similarity(prompt)
		if score > closest_score:
			closest_score = score
			closest_str = s
	
	return closest_str
