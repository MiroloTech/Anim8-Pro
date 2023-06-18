extends AnimLayer
class_name AnimAudio

var volume : float = 0.0
var bus : AnimBUS = null

var audio_file : AudioStreamWAV = null
var audio_player : AudioStreamPlayer = null

func load_file(local_path : String):
	if not local_path.ends_with(".wav"):
		pass # Convert to WAV with ffmpeg
	audio_file = load(local_path)
	
	audio_player = AudioStreamPlayer.new()
	audio_player.volume_db = volume
	audio_player.stream = audio_file
	# audio_player.bus = bus.bus_tag

enum WAVEFORM_DETAIL {
	HIGH,
	LOW
}

func get_waveform_preview(detail : WAVEFORM_DETAIL = WAVEFORM_DETAIL.HIGH):
	if audio_file == null: push_error("Tried to acces data from WAV audio stream, that is null..."); return
	
	var bytes = audio_file.data
	var final : Array[float]
	
	var floats : Array[float] = []
	for i in range(0, bytes.size(), 2):
		var b = bytes[i]
		var bn = bytes[i+1]
		var f = b | (bn << 8) if bn < 128 else ((abs(bn - 256) << 8) * signf(bn - 256))
		final.append(f * 0.00005) # * 0.00005
	
	var clipped_final : Array[float] = []
	
	for id in range(0, final.size(), (2000 if detail == WAVEFORM_DETAIL.LOW else 200)):
		clipped_final.append(final[id])
	
	return clipped_final

