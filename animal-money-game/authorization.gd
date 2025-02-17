extends Node

@onready var login_input = $VBoxContainer/Login
@onready var password_input = $VBoxContainer/Password
@onready var message_panel = $MessagePanel  # Reference to the Panel
@onready var message_label = $MessagePanel/MessageLabel  # Reference to the Label
@onready var message_bg = $MessageBackground  # Now a Panel instead of ColorRect

const login = "Login123"
const password = "Password123"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_button_login_pressed() -> void:
	if (login_input.text == login and password_input.text == password):
		show_message("You authorized", Color.DARK_GREEN)
		print('d')
	else:
		show_message("Wrong login or password", Color.DARK_RED)
		print("s")

func show_message(text: String, color: Color):
	message_label.text = text
	message_label.add_theme_color_override("font_color", color)
	message_bg.show()
	message_panel.show()
	await get_tree().create_timer(2.5).timeout
	message_panel.hide()
	message_bg.hide()

func _on_button_close_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
