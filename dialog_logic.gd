extends Node

@onready var dialogueLineUI = $"../MarginContainer/Panel/DialogueLine"
@onready var speakerPanelUI = $"../MarginContainer/Panel2"
@onready var speakerNameUI = $"../MarginContainer/Panel2/speakerName"
@onready var dialogueOptions = $"../DialogueOptions"
@onready var sprite = $"../Sprite2D"
@onready var arrow = $"../Arrow"
@onready var audioPlayer = $"../AudioStreamPlayer2D"
@onready var trade_ui = $"../../TradeUI"

@export var character_scene: PackedScene
@export var tradeUI_scene: PackedScene 

var dialogue_path: String
var dialogue_data: Dictionary = {}
var dialogue_id: int = 1
var areDiologueOptionsOn: bool = false
	
var button_theme = preload("res://assets/themes/theme.tres")

var dialogue_scenes: Dictionary = {
	"res://Dialogues/foxClover.json" : "res://assets/menu/bg3.png",
	"res://Dialogues/foxShell.json" : "res://assets/menu/bg.jpg",
	"res://Dialogues/eagleShell.json" : null,
}

var isTalking: bool = false
var dialogueStarted: bool = false

const speakerColors: Dictionary = {
	"Барс": "#1d4381",
	"Лиса": "#ff8720",
	"Волк": "#434043",
	"Беркут": "#000000",
}

const speakerSprites: Dictionary = {
	"Барс": "res://assets/characters/bars.png",
	"Лиса": "res://assets/characters/fox.png",
	"Волк": "res://assets/characters/wolf.png",
	"Беркут": "res://assets/characters/berkut.png",
}

const speakerVoices: Dictionary = {
	"Барс": "res://assets/sfx/Bars.wav",
	"Лиса": "res://assets/sfx/Fox.wav",
	"Волк": "res://assets/sfx/Wolf.wav",
	"Беркут": "res://assets/sfx/Wolf.wav",
}

const itemSprites: Dictionary = {
	"Лист": "res://assets/money/leafyLeaf.png",
	"Клевер": "res://assets/money/clover.png",
	"Ракушка": "res://assets/money/rakushka.png",
	"Лампа": "res://assets/money/fonarik.png",
}

func _ready() -> void:
	Global.connect("dialogueEnd", endDialogue)
	Global.connect("startTrade", createTrade)
	Global.connect("newItem", hideWindow)
	Global.connect("newItemGiven", showWindow)

func _process(delta: float) -> void:
	if get_parent().visible and !dialogueStarted:
		dialogue_data = load_dialogue(dialogue_path)
		dialogue_id = 1
		startNewLine()
		dialogueStarted = true

	if Input.is_action_just_pressed("left_click") and !isTalking and get_parent().visible and !areDiologueOptionsOn:
		startNewLine()

func load_dialogue(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			return json.get_data()
		else:
			push_error("Failed to parse JSON: %s" % error)
	return {}

func startNewLine():
	var allDialogueOptions = dialogueOptions.get_children()
	
	for i in allDialogueOptions:
		i.queue_free()
		
	var node = dialogue_data.get(str(dialogue_id), null)

	if node == null:
		Global.dialogueEnd.emit(dialogue_scenes[dialogue_path])
		return

	if node.has("text") and node["text"].begins_with("Trade:"):
		Global.emit_signal("startTrade", node["text"].substr(6))
		dialogue_id = node.get("next", dialogue_id + 1)
		return
	
	if node.has("text"):
		var parts = node["text"].split(":")
		if parts.size() >= 2:
			var speaker = parts[0].strip_edges()
			var line = parts[1].strip_edges()
			processLine({
				"speakerName": speaker,
				"dialogueLine": line
			})
	if node.has("item"):
		var itemDesc = {"sprite": itemSprites[node["item"]["sprite"]], "amount": node["item"]["amount"], "name": node["item"]["sprite"]}
		Global.newItem.emit(itemDesc)
		dialogue_id = node.get("next", dialogue_id + 1)
		return
	
	if node.has("choices"):
		areDiologueOptionsOn = true
		for choice in node["choices"]:
			add_choice_button(choice["text"], choice["next"])
	else:
		dialogue_id = node.get("next", dialogue_id + 1)

func processLine(lineInfo: Dictionary):
	arrow.visible = false
	var style = speakerPanelUI.get_theme_stylebox("panel")
	style.bg_color = speakerColors[lineInfo["speakerName"]]  
	sprite.texture = load(speakerSprites[lineInfo["speakerName"]])
	speakerPanelUI.add_theme_stylebox_override("panel", style)
	speakerNameUI.text = lineInfo["speakerName"]
	audioPlayer.stream = load(speakerVoices[lineInfo["speakerName"]])
	var dialogueLine = lineInfo["dialogueLine"]
	isTalking = true
	audioPlayer.play()
	dialogueLineUI.text = ""
	for char in dialogueLine:
		dialogueLineUI.text += char
		await get_tree().create_timer(0.015).timeout
	
	arrow.visible = true
	audioPlayer.stop()
	isTalking = false

func add_choice_button(text: String, next_id: int):
	var button = Button.new()
	button.text = text
	button.theme = button_theme
	button.size = Vector2(600, 300)
	button.connect("pressed", func():
		if not isTalking:
			areDiologueOptionsOn = false
			dialogue_id = next_id
			startNewLine()
	)
	dialogueOptions.add_child(button)

func createCharacter():
	var character = character_scene.instantiate()
	character.position = Vector2(800, 370)
	character.scale = Vector2(0.7, 0.7)
	get_parent().get_parent().add_child(character)

func createTrade(parsed_line):
	var trade_info: Array = parsed_line.split(";")

	trade_info[0] = trade_info[0].lstrip(" ")
	trade_info[0] = speakerSprites[trade_info[0]]

	trade_info[1] = trade_info[1].split("-")
	trade_info[2] = trade_info[2].split("-")

	trade_info[1] = {"sprite": itemSprites[trade_info[1][0]], "amount": trade_info[1][1], "name": trade_info[1][0]}
	trade_info[2] = {"sprite": itemSprites[trade_info[2][0]], "amount": trade_info[2][1], "name": trade_info[2][0]}

	
	trade_ui.visible = true
	trade_ui.setTrade(trade_info)

	get_parent().visible = false

func hideWindow():
	get_parent().visible = false
	
func showWindow():
	get_parent().visible = true
	
func endDialogue(path):
	get_parent().hide()
	dialogueStarted = false
	dialogue_id = 1
	createCharacter()
