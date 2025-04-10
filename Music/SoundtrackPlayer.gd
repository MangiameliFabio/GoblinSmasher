extends AudioStreamPlayer

var _target_db = 0
var _current_db = -40.0

func _ready() -> void:
	_target_db = volume_db
	volume_db = _current_db

func play_sondtrack(path: String):
	if playing:
		while _current_db > -40:
			_current_db = clamp(_current_db - get_process_delta_time() * 50, -80, _target_db)
			volume_db = _current_db
			await get_tree().process_frame
	
	var new_stream : AudioStream = load(path)
	
	stream = new_stream
	play()
	
	while _current_db < _target_db:
		_current_db = clamp(_current_db + get_process_delta_time() * 100, -80, _target_db)
		volume_db = _current_db
		await get_tree().process_frame
	
