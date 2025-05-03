extends Area2D

signal npc_interacted

@onready var sprite: Sprite2D = $Sprite2D

var interacted := false

func _ready() -> void:
	print("READY: sprite =", sprite)

func _on_body_entered(body: Node2D) -> void:
	if !interacted:
		interacted = true
		emit_signal("npc_interacted")
		
		queue_free()

func set_texture(texture: Texture2D) -> void:
	if sprite == null:
		push_error("Sprite is null!")
	else:
		sprite.texture = texture
