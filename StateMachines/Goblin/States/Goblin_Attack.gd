extends GoblinBaseState

@export var DamageArea : Area2D

func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	character.Body.velocity = Vector2.ZERO

	if Vector2.UP.dot(character.last_move_dir) > 0.7:
		character.Sprite.play("AttackUp")
	elif Vector2.DOWN.dot(character.last_move_dir) > 0.7:
		character.Sprite.play("AttackDown")
	else:
		character.Sprite.play("AttackLeftRight")
	$"../../CharacterBody2D/HitGoblin".play()
	
	character.Sprite.animation_finished.connect(_on_anim_finished)
	character.Sprite.frame_changed.connect(_on_frame_changed)

func exit() -> void:
	character.Sprite.animation_finished.disconnect(_on_anim_finished)
	character.Sprite.frame_changed.disconnect(_on_frame_changed)

func _on_anim_finished():
	state_machine.transition_to("Idle", {"WaitTime": 2})

func _on_frame_changed():
	if character.Sprite.frame  == 3:
		var nodes := DamageArea.get_overlapping_bodies()
		for node in nodes:
			var player := node.get_parent() as PlayerKnight
			var dir_to_player = character.Body.global_position.direction_to(player.Body.global_position)
			dir_to_player = dir_to_player.normalized()
			if character.last_move_dir.dot(dir_to_player) > 0:
				character.apply_knockback(-dir_to_player, 700, true)
			player.Block.play(0.1)
