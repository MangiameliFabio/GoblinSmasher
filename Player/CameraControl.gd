extends Camera2D
class_name CameraControl

var _min_pos : Vector2 = Vector2.ZERO
var _max_pos : Vector2 = Vector2.ZERO

func _ready() -> void:
	var view_rect = get_viewport_rect()
	
	_min_pos.y = view_rect.size.y / 2
	_max_pos.y = Global.GameInstance.map_size.y - view_rect.size.y / 2
	
	_min_pos.x = view_rect.size.x / 2
	_max_pos.x = Global.GameInstance.map_size.x - view_rect.size.x / 2

func update_camera_position(pos: Vector2):
	var new_position : Vector2 = pos
	new_position.y = clamp(new_position.y, _min_pos.y, _max_pos.y)
	new_position.x = clamp(new_position.x, _min_pos.x, _max_pos.x)
	
	global_position = lerp(global_position, new_position, 0.2)
