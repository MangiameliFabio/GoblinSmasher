extends GoblinBaseState

@export var StunDuration : float = 0.35

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	character.prevent_flip = true
	
	if not _msg.has("DontEndAnim"):
		character.Sprite.play("Idle")
	
	await get_tree().create_timer(StunDuration).timeout
	if character.dead: return
	state_machine.transition_to("Idle")

func exit() -> void:
	character.prevent_flip = false
	character.stunned = false
