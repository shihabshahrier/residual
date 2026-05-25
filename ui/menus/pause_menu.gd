extends CanvasLayer

@onready var resume_button: Button = $Control/MarginContainer/VBoxContainer/ResumeButton
@onready var menu_button: Button = $Control/MarginContainer/VBoxContainer/MenuButton

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			unpause()
		else:
			pause()

func pause() -> void:
	get_tree().paused = true
	show()
	resume_button.grab_focus()

func unpause() -> void:
	get_tree().paused = false
	hide()

func _on_resume_pressed() -> void:
	unpause()

func _on_menu_pressed() -> void:
	unpause()
	if has_node("/root/SceneManager"):
		get_node("/root/SceneManager").change_scene("res://ui/menus/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
