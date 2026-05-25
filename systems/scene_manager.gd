class_name SceneManager
extends Node

## Autoload for handling global scene transitions and game state (e.g. pausing).

signal transition_finished

func change_scene(scene_path: String) -> void:
	# For the vertical slice prototype, we just do a direct change.
	# A full production version would instantiate a CanvasLayer with a ColorRect
	# and use a Tween to fade out before changing, then fade back in.
	get_tree().change_scene_to_file(scene_path)
	emit_signal("transition_finished")

func quit_game() -> void:
	get_tree().quit()
