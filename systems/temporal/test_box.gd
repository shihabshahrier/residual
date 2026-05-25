class_name TestBox
extends RigidBody3D

## A physical box that can be pushed around and rewound.

var temporal_manager: Node = null

func _init() -> void:
	add_to_group("rewindable")

func _ready() -> void:
	if has_node("/root/TemporalManager"):
		temporal_manager = get_node("/root/TemporalManager")
		temporal_manager.register_rewindable(self)

func _physics_process(_delta: float) -> void:
	# Keep recording state every frame for the prototype
	if temporal_manager:
		temporal_manager.record_snapshot() # Note: In a real game, this might run on a timer instead of per-frame for everything

func save_state() -> PhysicsSnapshot3D:
	var snapshot := PhysicsSnapshot3D.new()
	snapshot.position = global_position
	snapshot.rotation = global_rotation
	snapshot.linear_velocity = linear_velocity
	snapshot.timestamp = Time.get_unix_time_from_system()
	return snapshot

func load_state(snapshot: PhysicsSnapshot3D) -> void:
	global_position = snapshot.position
	global_rotation = snapshot.rotation
	linear_velocity = snapshot.linear_velocity
