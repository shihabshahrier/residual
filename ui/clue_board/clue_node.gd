class_name ClueNode
extends GraphNode

## Visual representation of an EpistemicNodeData in the GraphEdit.

@export var data_id: String = ""

@onready var desc_label: Label = $DescriptionLabel

func setup(node_data: EpistemicNodeData) -> void:
	data_id = node_data.id
	title = node_data.title
	name = node_data.id
	position_offset = node_data.graph_position
	
	if desc_label != null:
		desc_label.text = node_data.description
		
	# Enable input (left) and output (right) ports on the first slot (index 0)
	set_slot(0, true, 0, Color.AQUA, true, 0, Color.AQUA)

func get_data_id() -> String:
	return data_id
