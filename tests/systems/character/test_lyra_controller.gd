extends GutTest

var controller: LyraController

func before_each() -> void:
	controller = load("res://systems/character/lyra_controller.gd").new()
	add_child_autoqfree(controller)

func test_is_rewindable() -> void:
	assert_true(controller.is_in_group("rewindable"), "LyraController should be in 'rewindable' group")

func test_temporal_save_and_load() -> void:
	# Mock some state
	controller.global_position = Vector3(10, 5, 10)
	controller.velocity = Vector3(1, 0, 1)
	controller.current_anim = "walk"
	
	var snapshot: PhysicsSnapshot3D = controller.save_state()
	
	assert_eq(snapshot.position, Vector3(10, 5, 10), "Saved position should match")
	assert_eq(snapshot.linear_velocity, Vector3(1, 0, 1), "Saved velocity should match")
	assert_eq(snapshot.animation_state, "walk", "Saved animation state should match")
	
	# Change state
	controller.global_position = Vector3(0, 0, 0)
	controller.velocity = Vector3(0, 0, 0)
	controller.current_anim = "idle"
	
	# Load state back
	controller.load_state(snapshot)
	
	assert_eq(controller.global_position, Vector3(10, 5, 10), "Loaded position should match snapshot")
	assert_eq(controller.velocity, Vector3(1, 0, 1), "Loaded velocity should match snapshot")
	assert_eq(controller.current_anim, "walk", "Loaded animation should match snapshot")
