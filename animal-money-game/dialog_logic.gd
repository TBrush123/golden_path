extends Node

@onready var dialogueLineUI = $"../Panel/DialogueLine"
@onready var speakerPanelUI = $"../Panel2"
@onready var speakerNameUI = $"../Panel2/speakerName"
@onready var sprite = $"../Sprite2D"
@onready var arrow = $"../Arrow"
@onready var audioPlayer = $"../AudioStreamPlayer2D"
	
@export var character_scene: PackedScene
@export var tradeUI_scene: PackedScene 

var isTalking: bool = false
var dialogueCount: int = 0

var leafSprite = "res://assets/money/leafyLeaf.png"
var cloverSprite = "res://assets/money/clover.png"

signal dialogueEnd
signal startTrade

const dialogue_lines: Array[String] = [
	"Лиса: Привет, Барс!",
	"Барс: О, привет, Лиса! Что-то случилось?",
	"Лиса: Я принесла тебе редкий клевер, четырехлистный! Продаю всего за... сто листочков.",
	"Лиса: -",
	"Барс: Сто? Ох, но у меня нет столько… А так хочется этот клевер!",
	"Лиса: Ну, если нет, то я найду другого покупателя.",
	"Волк: Эй, Барс, погоди-ка. Ты правда готов отдать сто листочков за один клевер?",
	"Барс: Ну… Да, ведь он редкий!",
	"Волк: Может, и редкий, но не настолько. Лиса просто проверяет тебя. Она хитрая, ей важны не столько листочки, сколько твоя доверчивость.",
	"Лиса: Ах, ты догадался, Волк! Да, я проверяла Барса. Хотела узнать, умеет ли он задумываться перед сделкой.",
	"Барс: Значит, ты меня обманула?",
	"Лиса: Не совсем. Я хотела, чтобы ты понял: всегда стоит думать, прежде чем соглашаться.",
	"Лиса: Ладно, по-честному он стоит всего десять листочков. Берешь?",
	"Лиса: -",
	"Барс: Конечно! Спасибо, Волк. Теперь я буду осторожнее.",
]

const speakerColors: Dictionary = {
	"Барс": "#1d4381",
	"Лиса": "#ff8720",
	"Волк": "#434043"
}

const speakerSprites: Dictionary = {
	"Барс": "res://assets/characters/bars.png",
	"Лиса": "res://assets/characters/fox.png",
	"Волк": "res://assets/characters/wolf.png"
}

const speakerVoices: Dictionary = {
	"Барс": "res://assets/sfx/Bars.wav",
	"Лиса": "res://assets/sfx/Fox.wav",
	"Волк": "res://assets/sfx/Wolf.wav"
}
func _ready() -> void:
	connect("dialogueEnd", createCharacter)
	connect("startTrade", createTrade)
	connect("dialogueEnd", get_parent().queue_free)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click") and !isTalking and get_parent().visible:
		dialogueCount += 1
		if dialogueCount == 3 or dialogueCount == 13:
			emit_signal("startTrade", dialogueCount)
		elif dialogueCount >= len(dialogue_lines):
			dialogueEnd.emit()
		else:
			processLine(parseLine(dialogue_lines[dialogueCount]))
			
func parseLine(line: String):
	var lineInfo = line.split(":")
	assert(len(lineInfo) >= 2)
	return {
		"speakerName": lineInfo[0],
		"dialogueLine": lineInfo[1]
	}
	
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
	for i in dialogueLine:
		dialogueLineUI.text += i
		await get_tree().create_timer(0.015).timeout
		
	arrow.visible = true
	audioPlayer.stop()
	isTalking = false
	
func createCharacter():
	var character = character_scene.instantiate()
	character.position = Vector2(800, 370)
	character.scale = Vector2(0.7, 0.7)
	get_parent().get_parent().add_child(character)
	
func createTrade(line):
	var tradeUI = tradeUI_scene.instantiate()
	var item1: Dictionary 
	var item2: Dictionary
	
	item1["sprite"] = load(leafSprite)
	item2["sprite"] = load(cloverSprite)
	
	if line == 3:
		item1["amount"] = 100
	else:
		item1["amount"] = 10
	
	item2["amount"] = 1
	
	tradeUI.setTrade(item1, item2, line)
	tradeUI.position = Vector2(800, 370)
	
	get_parent().get_parent().add_child(tradeUI)
	get_parent().visible = false
