extends Node2D
class_name Goblin

@export var NavAgent : NavigationAgent2D
@export var Body : CharacterBody2D
@export var CollisionShape : CollisionShape2D
@export var Sprite : AnimatedSprite2D
@export var MovementSpeed : float = 10
@export var Health : float = 3
@export var Friction : float = 50
@export var StateMachine : GoblinStateMachine
@export var Aggresive : bool = true

var last_move_dir : Vector2 = Vector2.ZERO
var stunned : bool = false
var prevent_flip : bool = false
var dead : bool = false

func set_target_position(target: Vector2):
	NavAgent.target_position = target

func _process(delta: float) -> void:
	if prevent_flip: return
	if Body.velocity.dot(Vector2.RIGHT) < 0:
		Sprite.flip_h = true
	elif Body.velocity.dot(Vector2.RIGHT) > 0:
		Sprite.flip_h = false

func _physics_process(delta: float) -> void:
	Body.move_and_slide()
	
	var friction_dir = -Body.velocity.normalized()
	Body.velocity = Body.velocity + friction_dir * Friction
	
	if Body.velocity.length() <= 0.1:
		Body.velocity = Vector2.ZERO
	
func take_damage(damage: float):
	Global.Friendly = false
	if not Aggresive:
		Aggresive = true
		SoundtrackPlayer.play_sondtrack("res://Music/Chariot_Battle_LOOP_175bpm.wav")
	sprite_flash()
	Health -= damage
	if Health <= 0:
		StateMachine.transition_to("Death")
		CollisionShape.disabled = true
		
		Global.GameInstance.killed_goblins += 1
		
		if Global.GameInstance.killed_goblins >= Global.GameInstance.MaxSpawnedGoblins:
			Global.GameInstance.open_path()

func apply_knockback(dir: Vector2, force_strength: float, dont_abort_anim: bool = false):
	stunned = true
	prevent_flip = true
	Body.velocity = dir * force_strength
	
	if dont_abort_anim:
		StateMachine.transition_to("Stunned", {"DontEndAnim": true})
	else:
		StateMachine.transition_to("Stunned")

func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(Sprite, "modulate:v", 1, 0.125).from(100)
