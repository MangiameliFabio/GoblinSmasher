extends Node
class_name Game

@export var GroundLayer : TileMapLayer
@export var NavigationRegion : NavigationRegion2D
@export var MaxSpawnedGoblins : float = 30
@export var TargetPoint : Node2D
@export var LevelTriggerCollision : CollisionShape2D
@export var ShowPathIfFrendly : bool = false

var spawned_goblins : float = 0
var killed_goblins : float = 0

var Player : PlayerKnight = null
var map_size : Vector2 = Vector2.ZERO

func _ready() -> void:
	if ShowPathIfFrendly and Global.Friendly:
		open_path()
		
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _enter_tree() -> void:
	Global.GameInstance = self
	map_size = GroundLayer.get_used_rect().size * GroundLayer.tile_set.tile_size
	
func open_path():
	Player.activate_path_finder(TargetPoint)
	
	LevelTriggerCollision.disabled = false
