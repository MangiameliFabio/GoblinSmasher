extends Node
class_name PlayerInput

enum Movement {
	NONE,
	LEFT,
	RIGHT,
	UP,
	DOWN
}

var movment_input : Vector2 = Vector2.ZERO
var attack_input : bool = false
var dash_input : bool = false

var last_hor_dir : Movement = Movement.NONE

func _process(delta: float) -> void:
	attack_input = Input.is_action_just_pressed("Attack")
	dash_input = Input.is_action_just_pressed("Dash")
	
	var new_movement := Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down"))
	var vec_len := new_movement.length_squared()
	if vec_len > 1: new_movement = new_movement.normalized()
	movment_input = new_movement
	
	if new_movement.x > 0:
		last_hor_dir = Movement.RIGHT
	elif new_movement.x < 0:
		last_hor_dir = Movement.LEFT
