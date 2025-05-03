extends Node

@onready var leafspawner: Node2D = $"LeafSpawner"
@onready var leafCounter: Label = $"../LeafCounter/Label"
@onready var fade: ColorRect = $"../FadeRect"
@onready var dialogueLogic = $"../DialogueWindow/DialogLogic"
@onready var counterCurrency: Sprite2D = get_node("../LeafCounter").get_child(1)

@export var dialogueWindow_scene: PackedScene
@export var npc_scene: PackedScene

var world: int = 0

var isDialogueOpen = false
var npcTriggered = false
var npcSpawned = false


func _ready() -> void:
	Global.connect("dialogueInit", show)
	Global.connect("dialogueEnd", on_dialogue_end)

func show(dialogueName):
	$"../DialogueWindow/DialogLogic".dialogue_path = dialogueName
	get_parent().get_node("Character").queue_free()
	leafspawner.stopTimer()
	$"../DialogueWindow".visible = true

func _process(delta: float) -> void:
	match world:
		0:
			counterCurrency.texture = load("res://assets/money/leafyLeaf.png")
			if int(leafCounter.text) == 1 and !isDialogueOpen:
				isDialogueOpen = true
				Global.dialogueInit.emit("res://Dialogues/foxClover.json")
		1:
			counterCurrency.texture = load("res://assets/money/clover.png")
			if not Global.isNPCSpawned:
				spawn_npc(load("res://assets/characters/fox.png"), Vector2(1250, 390), Vector2(0.5, 0.5))
				Global.isNPCSpawned = true
			if npcTriggered:
				Global.dialogueInit.emit("res://Dialogues/foxShell.json")
				npcTriggered = false
		2:
			if not Global.isNPCSpawned:
				spawn_npc(load("res://assets/characters/berkut.png"), Vector2(1250, 390), Vector2(0.5, 0.5))
				Global.isNPCSpawned = true
			if npcTriggered:
				Global.dialogueInit.emit("res://Dialogues/eagleShell.json")
				npcTriggered = false
			
func on_dialogue_end(scene):
	if !scene:
		return
	await fade.fade_in(2.0).finished
	npcSpawned = false
	$"../Sprite2D".texture = load(scene)

	Global.isNPCSpawned = false
	match world:
		0:
			counter_currency_change(load("res://assets/money/leafyLeaf.png"))
		1:
			counter_currency_change(load("res://assets/money/clover.png"))

	world += 1
	Global.worldChanged.emit()
	await fade.fade_out(2.0).finished

func npc_interacted():
	npcTriggered = true

func spawn_npc(texture: Texture2D, position: Vector2, scale: Vector2) -> void:
	var npc = npc_scene.instantiate()
	npc.position = position
	npc.scale = scale
	get_tree().get_root().add_child(npc)
	npc.set_texture(texture)
	npc.connect("npc_interacted", Callable(self, "npc_interacted"))

func counter_currency_change(texture: Texture2D) -> void:
	counterCurrency.texture = texture
