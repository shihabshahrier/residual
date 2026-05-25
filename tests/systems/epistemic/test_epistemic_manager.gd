extends GutTest

var epistemic_manager: Node

func before_each() -> void:
	epistemic_manager = load("res://systems/epistemic/epistemic_manager.gd").new()
	add_child_autoqfree(epistemic_manager)

func test_add_clue_node() -> void:
	var node_data = load("res://systems/epistemic/epistemic_node_data.gd").new()
	node_data.id = "clue_01"
	node_data.type = 0 # SOURCE
	node_data.title = "A bloody palm print"
	
	epistemic_manager.add_node(node_data)
	assert_true(epistemic_manager.has_node("clue_01"), "Manager should have the added clue node")

func test_connect_nodes() -> void:
	var node1 = load("res://systems/epistemic/epistemic_node_data.gd").new()
	node1.id = "clue_01"
	epistemic_manager.add_node(node1)
	
	var node2 = load("res://systems/epistemic/epistemic_node_data.gd").new()
	node2.id = "hypothesis_01"
	epistemic_manager.add_node(node2)
	
	var success: bool = epistemic_manager.connect_nodes("clue_01", "hypothesis_01")
	assert_true(success, "Nodes should successfully connect")
	assert_true(epistemic_manager.are_connected("clue_01", "hypothesis_01"), "Nodes should be marked as connected")

func test_contradiction_detection() -> void:
	# Mock testing a contradiction check
	# Suppose linking hypothesis A and hypothesis B causes a contradiction
	var node1 = load("res://systems/epistemic/epistemic_node_data.gd").new()
	node1.id = "hyp_a"
	node1.type = 1 # HYPOTHESIS
	node1.mutually_exclusive_with.append("hyp_b")
	epistemic_manager.add_node(node1)
	
	var node2 = load("res://systems/epistemic/epistemic_node_data.gd").new()
	node2.id = "hyp_b"
	node2.type = 1 # HYPOTHESIS
	node2.mutually_exclusive_with.append("hyp_a")
	epistemic_manager.add_node(node2)
	
	epistemic_manager.connect_nodes("hyp_a", "hyp_b")
	assert_true(epistemic_manager.has_contradiction("hyp_a", "hyp_b"), "Manager should detect contradiction based on mutual exclusivity")
