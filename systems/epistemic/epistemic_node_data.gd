class_name EpistemicNodeData
extends Resource

## Data representation of a node in the Epistemic Graph (Clue Board).

enum NodeType {
	SOURCE,
	HYPOTHESIS,
	CONTRADICTION,
	CONCLUSION
}

@export var id: String = ""
@export var type: NodeType = NodeType.SOURCE
@export var title: String = ""
@export_multiline var description: String = ""

## IDs of other nodes that this node contradicts
@export var mutually_exclusive_with: Array[String] = []

## Visual position on the GraphEdit
@export var graph_position: Vector2 = Vector2.ZERO
