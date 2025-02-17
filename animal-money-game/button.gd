extends Button

@export var speed: float = 2.0  # Speed of the movement
@export var distance: float = 5.0  # Distance of the up-and-down movement
@export var hover_scale: float = 1.2  # Scale multiplier when hovered
@export var animation_speed: float = 8.0  # Speed of the scale transition

@onready var sprite: Sprite2D = $Sprite2D

var _original_position: Vector2
var _time: float = 0.0
var _original_scale: Vector2
var _target_scale: Vector2

func _ready():
	# Save the starting position
	_original_position = position
	
	_original_scale = sprite.scale
	_target_scale = _original_scale

func _process(delta):
	# Increment time based on speed
	_time += delta * speed
	
	# Calculate new y position with sine wave for smooth motion
	position.y = _original_position.y + sin(_time) * distance
	
	sprite.scale = lerp(sprite.scale, _target_scale, delta * animation_speed)

func _on_mouse_entered():
	# Set the target scale to the hover scale
	_target_scale = _original_scale * hover_scale

func _on_mouse_exited():
		# Reset the target scale to the original scale
	_target_scale = _original_scale
	


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
