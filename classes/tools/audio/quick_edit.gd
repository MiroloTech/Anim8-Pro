extends Node

# Splits video at position
func split(audio : AnimAudio, time : float) -> Array[AnimAudio]:
	audio.warn_edit()
	
	var start : float = audio.start_pos
	var end : float = start + audio.length
	
	if time != clampf(time, start, end): return []
	
	var data = audio.audio_stream.data
	var split = floor((time - start) / (end - start) * data.size())
	
	
	var c1data = data.slice(0, split)
	var c2data = data.slice(split, data.size())
	
	var c1 = AnimAudio.new()
	var c1stream = AudioStreamWAV.new()
	c1stream.data = c1data
	c1.audio_stream = c1stream
	
	var c2 = AnimAudio.new()
	var c2stream = AudioStreamWAV.new()
	c2stream.data = c2data
	c2.audio_stream = c2stream
	
	return [c1, c2]


# Changes speed of track
#func scale(audio : AnimAudio, factor : float = 1.0) -> AnimAudio:
#    return audio


# Changes pitch of track
func pitch(audio : AnimAudio, factor : float = 1.0) -> AnimAudio:
	audio.audio_player.pitch_scale = factor
	return audio

# Changes volume of track
func amplify(audio : AnimAudio, volume : float = 0.0) -> AnimAudio:
	audio.audio_player.volume = volume
	return audio
