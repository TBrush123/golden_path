extends CharacterBody2D

@export var flip_speed: float = 10.0
@onready var sprite: Sprite2D = $Sprite2D

var speed = 400.0
var click_position = Vector2(0, 0)

var target_scale: Vector2 = Vector2(0.7, 0.7)
var isFacingRight = true

func _ready():
	$"../Logic".connect("dialogueInit", queue_free)
	target_scale = scale
	click_position = Vector2(position.x, position.y)
	
func _physics_process(delta):
	if Input.is_action_just_pressed("left_click"):
		click_position = get_global_mouse_position()
		
		var targetPosition = (click_position - position).normalized()
		if (targetPosition.x < 0 and isFacingRight) or (targetPosition.x > 0 and !isFacingRight):
			flip()

		velocity = targetPosition * speed
		
	if position.distance_to(click_position) > 3:
		move_and_slide()
	

func flip() -> void:
	if isFacingRight:
		target_scale = Vector2(-0.7, 0.7)
	else:
		target_scale = Vector2(0.7, 0.7)
	isFacingRight = !isFacingRight
	
func _process(delta: float) -> void:
	sprite.scale = sprite.scale.lerp(target_scale, flip_speed * delta)
