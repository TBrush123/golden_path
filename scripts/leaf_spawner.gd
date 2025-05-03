extends Node

signal dialogueStart

@export var leaf_scene: PackedScene  # Assign the leaf scene in the Inspector
@export var spawn_area_width: float = 1600  # Adjust based on map size
@export var min_leaves: int = 1
@export var max_leaves: int = 3
@export var spawn_interval: float = 1  # Time between spawns
@export var max_spawns: int = 3

var currentSpawn: int = 0
var timer: Timer  # Timer for spawning

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_leaves()
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_spawn_leaves)
	add_child(timer)
	timer.start()
	

func _spawn_leaves():
	var leaf_count = randi_range(min_leaves, max_leaves)
	for i in range(leaf_count):
		spawn_leaf()
	currentSpawn += 1
	if currentSpawn == 3:
		dialogueStart.emit()

func spawn_leaf():
	var leaf = leaf_scene.instantiate()
	var spawn_x = randf_range(50, spawn_area_width - 50)
	var spawn_y = randf_range(-50, -200)
	leaf.position = Vector2(spawn_x, spawn_y)
	get_parent().get_parent().add_child(leaf)
