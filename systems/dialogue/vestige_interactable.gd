class_name VestigeInteractable
extends Area3D

## An interactive object that triggers Dialogue Manager when the player approaches and presses accept.

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var player_in_range: bool = false
var balloon_scene: PackedScene = preload("res://ui/dialogue_balloon/example_balloon.tscn")

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("ui_accept"):
		if dialogue_resource:
			var balloon = balloon_scene.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(dialogue_resource, dialogue_start)
			# Stop propagation so we don't accidentally toggle the scanner right after
			get_viewport().set_input_as_handled()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("rewindable"): # Lyra is in rewindable group
		player_in_range = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("rewindable"):
		player_in_range = false
