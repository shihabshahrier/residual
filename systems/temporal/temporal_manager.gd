extends Node

## Manages temporal state recording and rewinding for entities.

@export var max_snapshots: int = 300

var _snapshot_buffers: Dictionary = {}

func register_rewindable(node: Node) -> void:
	if not node.is_in_group("rewindable"):
		push_warning("TemporalManager: Node is not in 'rewindable' group.")
		return
	
	if not _snapshot_buffers.has(node):
		var buffer: Array[TemporalSnapshot] = []
		_snapshot_buffers[node] = buffer

func has_rewindable(node: Node) -> bool:
	return _snapshot_buffers.has(node)

func record_snapshot() -> void:
	# Iterate over keys, collecting valid nodes
	var invalid_nodes: Array[Node] = []
	
	for node in _snapshot_buffers:
		if is_instance_valid(node) and node.has_method("save_state"):
			var snapshot: TemporalSnapshot = node.save_state()
			var buffer: Array[TemporalSnapshot] = _snapshot_buffers[node]
			buffer.push_back(snapshot)
			
			if buffer.size() > max_snapshots:
				buffer.pop_front()
		else:
			invalid_nodes.push_back(node)
			
	# Cleanup invalidated nodes
	for node in invalid_nodes:
		_snapshot_buffers.erase(node)

func get_snapshots_for(node: Node) -> Array[TemporalSnapshot]:
	if _snapshot_buffers.has(node):
		return _snapshot_buffers[node]
	return []

func rewind_object(node: Node, steps: int) -> void:
	if not _snapshot_buffers.has(node):
		return
	
	var buffer: Array[TemporalSnapshot] = _snapshot_buffers[node]
	var size := buffer.size()
	
	if size == 0:
		return
		
	var target_index := clampi(size - 1 - steps, 0, size - 1)
	var snapshot: TemporalSnapshot = buffer[target_index]
	
	if node.has_method("load_state"):
		node.load_state(snapshot)
	
	# Trim timeline buffer if we actually rewound
	buffer.resize(target_index + 1)
