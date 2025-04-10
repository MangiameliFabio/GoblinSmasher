extends PlayerKnightBaseState

@export var DamageArea : Area2D
@export var SwordSounds : Array[AudioStreamRandomizer]

var dash_input_bufferd : bool = false
var attack_input_buffered : bool = false
var combo_count = 0
func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	if character.PlayerInputHandler.attack_input:
		attack_input_buffered = character.PlayerInputHandler.attack_input
	
	if not dash_input_bufferd:
		dash_input_bufferd = character.PlayerInputHandler.dash_input

	if dash_input_bufferd and character.can_dash:
		if character.Sprite.frame > 1:
			state_machine.transition_to("Dash")
		return

func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	character.Sprite.animation_finished.connect(_on_animation_finished)
	character.Sprite.frame_changed.connect(_on_frame_changed)
	
	character.prevent_flip = true
	var combo = 0
	if _msg.has("Combo"):
		combo = _msg["Combo"]

	combo_count = combo
	attack(combo)


func exit() -> void:
	character.Sprite.animation_finished.disconnect(_on_animation_finished)
	character.Sprite.frame_changed.disconnect(_on_frame_changed)
	
	character.prevent_flip = false
	attack_input_buffered = false
	dash_input_bufferd = false

func _on_animation_finished():
	if attack_input_buffered:
		if combo_count == 0:
			combo_count = 1
			attack_input_buffered = false
			state_machine.transition_to("Attack",{"Combo": combo_count})
		elif combo_count == 1:
			combo_count = 0
			attack_input_buffered = false
			state_machine.transition_to("Attack",{"Combo": combo_count})
	else:
		state_machine.transition_to("Idle")

func _on_frame_changed():
	if character.Sprite.frame == 1:
		var enemies := DamageArea.get_overlapping_bodies()
		for e in enemies:
			var enemy = e.get_parent()
			if not enemy is Goblin: return
			
			var dir_to_enemy = character.Body.global_position.direction_to(enemy.Body.global_position)
			dir_to_enemy = dir_to_enemy.normalized()
			var movement_dir = character.PlayerInputHandler.movment_input
			if is_zero_approx(movement_dir.length_squared()):
				movement_dir = character.last_mov_dir
			if movement_dir.dot(dir_to_enemy) > 0:
				enemy.apply_knockback(dir_to_enemy, 700)
				enemy.take_damage(1)
				character.SFX.stream = SwordSounds[2]
				character.SFX.play(0)

func attack(combo: int):
	var attack_dir = character.PlayerInputHandler.movment_input
	
	if attack_dir.y > 0:
		character.Sprite.play("%dAttackDown" % combo)
		character.Body.velocity = Vector2.DOWN * 2500
	elif attack_dir.y < 0:
		character.Sprite.play("%dAttackUp" % combo)
		character.Body.velocity = Vector2.UP * 2500
	elif attack_dir.x < 0:
		character.Sprite.flip_h = true
		character.Sprite.play("%dAttackLeftRight" % combo)
		character.Body.velocity = Vector2.LEFT * 2500
	elif attack_dir.x > 0:
		character.Sprite.flip_h = false
		character.Sprite.play("%dAttackLeftRight" % combo)
		character.Body.velocity = Vector2.RIGHT * 2500
	else:
		if character.Sprite.flip_h:
			character.Sprite.play("%dAttackLeftRight" % combo)
			character.Body.velocity = Vector2.LEFT * 2500
		else:
			character.Sprite.play("%dAttackLeftRight" % combo)
			character.Body.velocity = Vector2.RIGHT * 2500
	
	character.SFX.stream = SwordSounds[combo]
	character.SFX.play(0)
	
	character.Body.move_and_slide()
