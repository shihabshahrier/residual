extends Control

@onready var start_button: Button = $MarginContainer/VBoxContainer/StartButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Start with focus on the Start button for controller/keyboard support
	start_button.grab_focus()

func _on_start_pressed() -> void:
	if has_node("/root/SceneManager"):
		get_node("/root/SceneManager").change_scene("res://levels/level_01.tscn")
	else:
		get_tree().change_scene_to_file("res://levels/level_01.tscn")

func _on_quit_pressed() -> void:
	if has_node("/root/SceneManager"):
		get_node("/root/SceneManager").quit_game()
	else:
		get_tree().quit()
