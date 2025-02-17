extends Node

@onready var leafspawner: Node2D = $"LeafSpawner"
@onready var leafCounter: Label = $"../LeafCounter/Label"

@export var dialogueWindow_scene: PackedScene

signal dialogueInit

var isDialogueOpen = false

func _ready() -> void:
	connect("dialogueInit", show)
	connect("dialogueInit", leafspawner.stopTimer)
	
func show():
	$"../DialogueWindow".visible = true
	$"../DialogueWindow/DialogLogic".processLine($"../DialogueWindow/DialogLogic".parseLine($"../DialogueWindow/DialogLogic".dialogue_lines[0]))
func _process(delta: float) -> void:
	if int(leafCounter.text) == 10 and !isDialogueOpen:
		isDialogueOpen = true
		dialogueInit.emit()
