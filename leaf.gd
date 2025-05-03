extends Area2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var counterLabel: Label = get_node("../LeafCounter").get_child(2)

var stop_y 
var speed = 200

func _ready() -> void:

	Global.connect("dialogueInit", leaf_del)
	animation.play("RESET")
	var offset : float = randf_range(0, animation.current_animation_length)
	animation.advance(offset)
	stop_y = randi_range(400, 600)

func leaf_del(body):
	queue_free()

func _process(delta):
	if position.y < stop_y:
		position.y += speed * delta  # Move downward
	else:
		position.y = stop_y  # Ensure it stops exactly at the point
		animation.stop()


func _on_body_entered(body: Node2D) -> void:
	counterLabel.text = str(int(counterLabel.text) + 1)
	queue_free()
