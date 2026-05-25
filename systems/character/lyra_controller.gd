class_name LyraController
extends CharacterBody3D

## Primary controller for Lyra Vey in a 2.5D environment.
## Implements 'rewindable' interface for the TemporalManager.

@export var move_speed: float = 5.0
@export var acceleration: float = 10.0
@export var deceleration: float = 15.0

var current_anim: String = "idle"

func _init() -> void:
	add_to_group("rewindable")

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, direction.x * move_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * move_speed, acceleration * delta)
		current_anim = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * delta)
		current_anim = "idle"
		
	if not is_on_floor():
		velocity.y -= 9.8 * delta
		
	move_and_slide()

# --- Temporal Reconstruction Interface ---

func save_state() -> PhysicsSnapshot3D:
	var snapshot := PhysicsSnapshot3D.new()
	snapshot.position = global_position
	snapshot.rotation = global_rotation
	snapshot.linear_velocity = velocity
	snapshot.animation_state = current_anim
	snapshot.timestamp = Time.get_unix_time_from_system()
	return snapshot

func load_state(snapshot: PhysicsSnapshot3D) -> void:
	global_position = snapshot.position
	global_rotation = snapshot.rotation
	velocity = snapshot.linear_velocity
	current_anim = snapshot.animation_state
