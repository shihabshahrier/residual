class_name ClueBoard
extends GraphEdit

## Main UI for the Epistemic Graph (Clue Board).

@export var clue_node_scene: PackedScene

func _ready() -> void:
	if has_node("/root/EpistemicManager"):
		var em = get_node("/root/EpistemicManager")
		em.node_added.connect(_on_epistemic_node_added)
		em.nodes_connected.connect(_on_epistemic_nodes_connected)
		
		# Load existing data
		for node_data in em.get_all_nodes():
			_on_epistemic_node_added(node_data)
			
		for conn in em.get_all_connections():
			_on_epistemic_nodes_connected(conn["from"], conn["to"])
			
	connection_request.connect(_on_connection_request)

func _on_epistemic_node_added(node_data: EpistemicNodeData) -> void:
	if clue_node_scene == null:
		push_error("ClueBoard: clue_node_scene is not assigned.")
		return
		
	var node: ClueNode = clue_node_scene.instantiate() as ClueNode
	if node != null:
		add_child(node)
		node.setup(node_data)

func _on_epistemic_nodes_connected(from_id: String, to_id: String) -> void:
	connect_node(from_id, 0, to_id, 0)

func _on_connection_request(from_node: StringName, _from_port: int, to_node: StringName, _to_port: int) -> void:
	if has_node("/root/EpistemicManager"):
		var em = get_node("/root/EpistemicManager")
		em.connect_nodes(String(from_node), String(to_node))
