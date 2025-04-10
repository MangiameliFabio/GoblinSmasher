extends Node2D
class_name PlayerKnight

@export var MovementSpeed : float = 10
@export var DashCooldwon : float = 1

@export var Sprite : AnimatedSprite2D
@export var Camera : CameraControl
@export var Body : CharacterBody2D
@export var PlayerInputHandler : PlayerInput
@export var Footsteps : AudioStreamPlayer2D
@export var SFX : AudioStreamPlayer2D
@export var Block : AudioStreamPlayer2D

@export var PathIndicator : Sprite2D

var last_mov_dir : Vector2 = Vector2.ZERO
var prevent_flip : bool = false
var can_dash : bool = true
var _path_target : Node2D = null

func _ready() -> void:
	Camera.make_current()
	Global.GameInstance.Player = self

func _process(delta: float) -> void:
	Camera.update_camera_position(Body.global_position)
	
	if _path_target:
		PathIndicator.updated_rotation(_path_target)
	
	if prevent_flip: return
	
	match PlayerInputHandler.last_hor_dir:
		PlayerInput.Movement.LEFT:
			Sprite.flip_h = true
		PlayerInput.Movement.RIGHT:
			Sprite.flip_h = false

func start_dash_cooldown():
	can_dash = false
	get_tree().create_timer(DashCooldwon).timeout.connect(func(): can_dash = true)

func activate_path_finder(target: Node2D):
	PathIndicator.activated = true
	
	_path_target = target
