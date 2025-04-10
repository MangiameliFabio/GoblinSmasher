extends GoblinBaseState

var _wait_time : float = 1

func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	if _wait_time <= 0:
		if not character.Aggresive:
			return
		state_machine.transition_to("Run")
	else:
		_wait_time -= _delta


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	character.Sprite.play("Idle")
	
	if _msg.has("WaitTime"):
		_wait_time = _msg["WaitTime"]


func exit() -> void:
	pass
