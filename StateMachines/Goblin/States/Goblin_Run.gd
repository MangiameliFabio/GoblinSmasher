extends GoblinBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	if character.stunned:
		state_machine.transition_to("Stunned")

	if character.Body.global_position.distance_to(Global.GameInstance.Player.Body.global_position) <= 60:
		state_machine.transition_to("Attack")

func physics_update(_delta: float) -> void:
	character.NavAgent.target_position = Global.GameInstance.Player.Body.global_position
	var path_position = character.NavAgent.get_next_path_position()
	var move_dir = character.Body.global_position.direction_to(path_position)
	
	character.Body.velocity = move_dir * _delta * character.MovementSpeed * 1000
	character.last_move_dir = move_dir

func enter(_msg := {}) -> void:
	character.Sprite.play("Run")


func exit() -> void:
	pass
