extends GoblinBaseState

var anim_started = false

func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if not anim_started and is_zero_approx(character.Body.velocity.length()):
		anim_started = true
		character.Sprite.play()

func enter(_msg := {}) -> void:
	character.Sprite.play("Death")
	character.Sprite.pause()
	character.dead = true

func exit() -> void:
	pass
