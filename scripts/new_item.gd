extends Node2D

@onready var itemSprite: Sprite2D = $Item
@onready var label: Label = $Label
@onready var timer: Timer = $Timer

func _ready() -> void:
	Global.connect("newItem", giveItem)
	

func giveItem(item):
	print(item)
	itemSprite.texture = load(item["sprite"])
	label.text = "Барс получил %s" % item["name"]
	
	visible = true
	var dialogueWindow = get_parent().get_node("DialogueWindow")
	dialogueWindow.visible = false
	
	timer.start()
	await timer.timeout
	
	Global.newItemGiven.emit()
	visible = false
	
	dialogueWindow.visible = true
