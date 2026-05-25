extends GutTest

var epistemic_manager: Node
var clue_board: ClueBoard

func before_each() -> void:
	epistemic_manager = load("res://systems/epistemic/epistemic_manager.gd").new()
	epistemic_manager.name = "EpistemicManager"
	
	var root = get_tree().root
	if root.has_node("EpistemicManager"):
		root.get_node("EpistemicManager").queue_free()
	root.add_child(epistemic_manager)
	
	clue_board = load("res://ui/clue_board/clue_board.tscn").instantiate() as ClueBoard
	add_child_autoqfree(clue_board)

func after_each() -> void:
	var root = get_tree().root
	if root.has_node("EpistemicManager"):
		root.get_node("EpistemicManager").queue_free()

func test_clue_board_populates_nodes() -> void:
	var node_data = load("res://systems/epistemic/epistemic_node_data.gd").new()
	node_data.id = "test_clue_1"
	node_data.title = "Test Clue"
	
	epistemic_manager.add_node(node_data)
	
	assert_true(clue_board.has_node("test_clue_1"), "ClueBoard should create a child node matching the added clue ID")
