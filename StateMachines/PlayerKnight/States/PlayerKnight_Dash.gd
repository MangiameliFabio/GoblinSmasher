extends PlayerKnightBaseState

@export var DashSpeed : float = 40
@export var DashDuration : float = 0.15

@export var DashSound : AudioStreamPlayer2D 

@onready var _current_dash_duration : float = DashDuration

var _dash_direction : Vector2 = Vector2.ZERO
var attack_input_buffered : bool = false

func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	if character.PlayerInputHandler.attack_input:
		attack_input_buffered = character.PlayerInputHandler.attack_input


func physics_update(_delta: float) -> void:
	if _current_dash_duration <= 0:
		if attack_input_buffered:
			attack_input_buffered = false
			state_machine.transition_to("Attack")
			return
		state_machine.transition_to("Idle")
		return 
	character.Body.velocity = _dash_direction * DashSpeed * _delta * 1000
	character.Body.move_and_slide()
	_current_dash_duration -= _delta

func enter(_msg := {}) -> void:
	character.Sprite.play("Dash")
	DashSound.play(0)
	character.Sprite.pause()
	_dash_direction = character.PlayerInputHandler.movment_input
	if _dash_direction == Vector2.ZERO:
		_dash_direction = character.last_mov_dir
	_current_dash_duration = DashDuration
	character.start_dash_cooldown()
	
func exit() -> void:
	attack_input_buffered = false
