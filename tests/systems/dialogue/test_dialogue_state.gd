extends GutTest

var epistemic_manager: Node
var dialogue_state: Node

func before_each() -> void:
	epistemic_manager = load("res://systems/epistemic/epistemic_manager.gd").new()
	epistemic_manager.name = "EpistemicManager"
	
	# We simulate the SceneTree structure by adding EpistemicManager under the root
	var root = get_tree().root
	if root.has_node("EpistemicManager"):
		root.get_node("EpistemicManager").queue_free()
	root.add_child(epistemic_manager)
	
	dialogue_state = load("res://systems/dialogue/dialogue_state.gd").new()
	add_child_autoqfree(dialogue_state)

func after_each() -> void:
	var root = get_tree().root
	if root.has_node("EpistemicManager"):
		root.get_node("EpistemicManager").queue_free()

func test_dialogue_state_clue_check() -> void:
	var node_data = load("res://systems/epistemic/epistemic_node_data.gd").new()
	node_data.id = "clue_dialogue_01"
	epistemic_manager.add_node(node_data)
	
	assert_true(dialogue_state.has_clue("clue_dialogue_01"), "DialogueState should see the clue from EpistemicManager")
	assert_false(dialogue_state.has_clue("missing_clue"), "DialogueState should return false for missing clue")
