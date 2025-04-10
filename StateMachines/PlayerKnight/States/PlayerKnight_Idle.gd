extends PlayerKnightBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	if character.PlayerInputHandler.movment_input.length_squared() > 0:
		state_machine.transition_to("Run")
		return
	
	if character.PlayerInputHandler.attack_input:
		state_machine.transition_to("Attack")
		return
		
	if character.PlayerInputHandler.dash_input and character.can_dash:
		state_machine.transition_to("Dash")
		return


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	character.Sprite.play("Idle")


func exit() -> void:
	pass
