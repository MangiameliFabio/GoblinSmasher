extends Node2D
class_name GoblinSpawner

@export var GoblinScene : PackedScene
@export var SpawnDuration : float = 3

var _spawn_timer : Timer

func _ready() -> void:
	if Global.Friendly: return
	
	_spawn_timer = Timer.new()
	add_child(_spawn_timer)
	_spawn_timer.start(SpawnDuration)
	_spawn_timer.timeout.connect(spawn)
	spawn()

func spawn():
	if Global.GameInstance.spawned_goblins >= Global.GameInstance.MaxSpawnedGoblins:
		return
	var goblin = GoblinScene.instantiate()
	add_child(goblin)
	
	goblin.global_position = global_position
	
	Global.GameInstance.spawned_goblins += 1 
