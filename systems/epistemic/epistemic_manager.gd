extends Node

## Manages the state of the Epistemic Graph (Clue Board), keeping track of nodes and connections.

signal node_added(node_data: EpistemicNodeData)
signal nodes_connected(from_id: String, to_id: String)
signal contradiction_detected(id_a: String, id_b: String)

## Dictionary of id -> EpistemicNodeData
var _nodes: Dictionary = {}

## Array of Dictionaries like {"from": String, "to": String}
var _connections: Array[Dictionary] = []

func add_node(node_data: EpistemicNodeData) -> void:
	if not _nodes.has(node_data.id):
		_nodes[node_data.id] = node_data
		node_added.emit(node_data)

func has_epistemic_node(id: String) -> bool:
	return _nodes.has(id)

func connect_nodes(from_id: String, to_id: String) -> bool:
	if not has_epistemic_node(from_id) or not has_epistemic_node(to_id):
		return false
		
	if are_connected(from_id, to_id):
		return false
		
	_connections.push_back({"from": from_id, "to": to_id})
	nodes_connected.emit(from_id, to_id)
	
	if has_contradiction(from_id, to_id):
		contradiction_detected.emit(from_id, to_id)
		
	return true

func are_connected(from_id: String, to_id: String) -> bool:
	for conn in _connections:
		if (conn["from"] == from_id and conn["to"] == to_id) or \
		   (conn["from"] == to_id and conn["to"] == from_id):
			return true
	return false

func has_contradiction(id_a: String, id_b: String) -> bool:
	if not has_epistemic_node(id_a) or not has_epistemic_node(id_b):
		return false
		
	var node_a: EpistemicNodeData = _nodes[id_a]
	var node_b: EpistemicNodeData = _nodes[id_b]
	
	if node_a.mutually_exclusive_with.has(id_b) or node_b.mutually_exclusive_with.has(id_a):
		return true
		
	return false

func get_all_nodes() -> Array[EpistemicNodeData]:
	var result: Array[EpistemicNodeData] = []
	for key in _nodes:
		result.push_back(_nodes[key])
	return result

func get_all_connections() -> Array[Dictionary]:
	return _connections
