class_name DialogueState
extends Node

## Autoload used by Godot Dialogue Manager to query the state of the investigation.

func has_clue(clue_id: String) -> bool:
	if has_node("/root/EpistemicManager"):
		var epistemic_manager = get_node("/root/EpistemicManager")
		if epistemic_manager.has_method("has_node"):
			return epistemic_manager.has_node(clue_id)
	return false

func has_contradiction(clue_a: String, clue_b: String) -> bool:
	if has_node("/root/EpistemicManager"):
		var epistemic_manager = get_node("/root/EpistemicManager")
		if epistemic_manager.has_method("has_contradiction"):
			return epistemic_manager.has_contradiction(clue_a, clue_b)
	return false

func are_clues_connected(clue_a: String, clue_b: String) -> bool:
	if has_node("/root/EpistemicManager"):
		var epistemic_manager = get_node("/root/EpistemicManager")
		if epistemic_manager.has_method("are_connected"):
			return epistemic_manager.are_connected(clue_a, clue_b)
	return false
