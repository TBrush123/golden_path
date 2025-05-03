extends Control

@onready var dialogueWindow: Control = $"../DialogueWindow"

@export var characterSprite: TextureRect
@export var giveSprite: TextureRect
@export var getSprite: TextureRect
@export var giveLabel: Label
@export var getLabel: Label

func setTrade(trade_info):
	characterSprite.texture = load(trade_info[0])
	
	giveLabel.text = str(trade_info[1]["amount"])
	getLabel.text = str(trade_info[2]["amount"])
	
	giveSprite.texture = load(trade_info[1]["sprite"])
	getSprite.texture = load(trade_info[2]["sprite"])
	
	Global.given_item = trade_info[2]

func _on_accept_pressed() -> void:
	visible = false
	$"../LeafCounter/Label".text = str(int($"../LeafCounter/Label".text) - int(giveLabel.text))
	Global.newItem.emit(Global.given_item)
	
