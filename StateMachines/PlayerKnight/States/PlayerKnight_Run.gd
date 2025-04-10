extends PlayerKnightBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	if character.PlayerInputHandler.movment_input.length_squared() <= 0:
		state_machine.transition_to("Idle")
		return
	
	if character.PlayerInputHandler.attack_input:
		state_machine.transition_to("Attack")
		return
		
	if character.PlayerInputHandler.dash_input and character.can_dash:
		state_machine.transition_to("Dash")
		return

func physics_update(_delta: float) -> void:
	var input = character.PlayerInputHandler.movment_input
	if input.length_squared() > 0:
		character.Body.velocity = input * character.MovementSpeed * _delta * 1000
		character.Body.move_and_slide()
		character.last_mov_dir = input

func enter(_msg := {}) -> void:
	character.Sprite.play("Run")
	character.Sprite.frame_changed.connect(_on_frame_changed)

func exit() -> void:
	character.Sprite.frame_changed.disconnect(_on_frame_changed)


func _on_frame_changed():
	match character.Sprite.frame:
		1:
			character.Footsteps.play()
		4:
			character.Footsteps.play()
	
