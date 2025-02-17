extends Control

@onready var dialogueWindow: Control = $"../DialogueWindow"

@export var giveSprite: Sprite2D
@export var getSprite: Sprite2D
@export var giveLabel: Label
@export var getLabel: Label

var currentLine: int
	
func setTrade(item1, item2, line):
	currentLine = line
	
	giveLabel.text = str(item1["amount"])
	getLabel.text = str(item2["amount"])
	
	giveSprite.texture = item1["sprite"]
	getSprite.texture = item2["sprite"]
	

func _on_accept_pressed() -> void:
	visible = false
	if currentLine == 13:
		$"../LeafCounter/Label".text = str(int($"../LeafCounter/Label".text) - 10)
		$"../NewItem".visible = true
		await get_tree().create_timer(3).timeout
		$"../NewItem".visible = false
	dialogueWindow.visible = true
	
