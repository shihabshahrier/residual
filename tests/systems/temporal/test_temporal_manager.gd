extends GutTest

## A dummy rewindable object for testing
class DummyRewindable extends Node2D:
	var velocity := Vector2.ZERO
	var current_anim := "idle"
	
	func _init() -> void:
		add_to_group("rewindable")
	
	func save_state() -> PhysicsSnapshot:
		var snapshot := PhysicsSnapshot.new()
		snapshot.position = position
		snapshot.rotation = rotation
		snapshot.linear_velocity = velocity
		snapshot.animation_state = current_anim
		snapshot.timestamp = Time.get_unix_time_from_system()
		return snapshot
	
	func load_state(snapshot: PhysicsSnapshot) -> void:
		position = snapshot.position
		rotation = snapshot.rotation
		velocity = snapshot.linear_velocity
		current_anim = snapshot.animation_state

var temporal_manager: Node
var dummy: DummyRewindable

func before_each() -> void:
	# Initialize TemporalManager and our dummy
	temporal_manager = load("res://systems/temporal/temporal_manager.gd").new()
	add_child_autoqfree(temporal_manager)
	
	dummy = DummyRewindable.new()
	add_child_autoqfree(dummy)

func test_register_rewindable() -> void:
	temporal_manager.register_rewindable(dummy)
	assert_true(temporal_manager.has_rewindable(dummy), "Manager should contain the dummy object")

func test_take_snapshot() -> void:
	temporal_manager.register_rewindable(dummy)
	dummy.position = Vector2(10, 10)
	dummy.velocity = Vector2(5, 5)
	
	temporal_manager.record_snapshot()
	
	var buffer: Array[TemporalSnapshot] = temporal_manager.get_snapshots_for(dummy)
	assert_eq(buffer.size(), 1, "Should have 1 snapshot")
	assert_eq(buffer[0].position, Vector2(10, 10), "Snapshot position should match")
	assert_eq(buffer[0].linear_velocity, Vector2(5, 5), "Snapshot velocity should match")

func test_circular_buffer_limit() -> void:
	temporal_manager.register_rewindable(dummy)
	temporal_manager.max_snapshots = 3
	
	for i in range(5):
		dummy.position = Vector2(i, i)
		temporal_manager.record_snapshot()
		
	var buffer: Array[TemporalSnapshot] = temporal_manager.get_snapshots_for(dummy)
	assert_eq(buffer.size(), 3, "Buffer should not exceed max_snapshots limit")
	assert_eq(buffer[0].position, Vector2(2, 2), "Oldest snapshot should have position 2,2 after shifting")
	assert_eq(buffer[2].position, Vector2(4, 4), "Newest snapshot should have position 4,4")

func test_rewind_object() -> void:
	temporal_manager.register_rewindable(dummy)
	
	dummy.position = Vector2(0, 0)
	temporal_manager.record_snapshot()
	
	dummy.position = Vector2(100, 100)
	temporal_manager.record_snapshot()
	
	# Rewind to the previous snapshot (index 0)
	temporal_manager.rewind_object(dummy, 1) # rewind 1 step
	
	assert_eq(dummy.position, Vector2(0, 0), "Object should be rewound to initial position")
