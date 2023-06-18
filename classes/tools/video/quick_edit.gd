extends Node

# Splits video at position
func split(video : AnimVideo, time : float) -> Array[AnimVideo]:
	if not video.is_ready: return []
	# Check if time is in video clip area
	var start = video.start_pos
	var end = start + video.length
	var fps = video.fps
	
	if time != clampf(time, start, end): return []
	
	var frame_clip_id : int = int((time - start) * fps) # ID at which the old frames array should be split
	
	# Clip 1
	var c1 = AnimVideo.new()
	var c1_frames : Array[Image] = []
	var c1_start_pos = video.start_pos
	c1.new_from_frames(c1_start_pos, c1_frames, fps)
	
	# Clip 2
	var c2 = AnimVideo.new()
	var c2_frames : Array[Image] = []
	var c2_start_pos = time
	c2.new_from_frames(c2_start_pos, c2_frames, fps)
	
	# Return two parts
	return [c1, c2]

# Changes speed of video
func change_speed(video : AnimVideo, speed_factor : float = 1.0) -> AnimVideo:
	video.warn_edit()
	var new_fps : int = int(float(video.fps) * speed_factor)
	video.fps = new_fps
	
	return video


