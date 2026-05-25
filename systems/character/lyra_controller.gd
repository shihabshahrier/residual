class_name LyraController
extends CharacterBody3D

## Primary controller for Lyra Vey in a 2.5D environment.
## Implements 'rewindable' interface for the TemporalManager.

@export var move_speed: float = 5.0
@export var acceleration: float = 10.0
@export var deceleration: float = 15.0

var current_anim: String = "idle"
var is_scanning: bool = false
var temporal_manager: Node = null

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var scanner_ui: CanvasLayer = $ScannerUI

func _init() -> void:
	add_to_group("rewindable")

func _ready() -> void:
	if has_node("/root/TemporalManager"):
		temporal_manager = get_node("/root/TemporalManager")
		temporal_manager.register_rewindable(self)


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
	
	if is_scanning:
		_update_raycast()

func _update_raycast() -> void:
	if not camera or not raycast: return
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_length := 1000.0
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * ray_length
	
	raycast.global_position = from
	raycast.target_position = raycast.to_local(to)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		is_scanning = !is_scanning
		scanner_ui.visible = is_scanning
		
	if is_scanning and temporal_manager:
		if event is InputEventMouseButton and event.pressed:
			var hit = raycast.get_collider()
			if hit and hit.is_in_group("rewindable"):
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					temporal_manager.rewind_object(hit, 1)
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					temporal_manager.rewind_object(hit, -1) # Negative step to go forward, though temporal_manager expects steps from newest to oldest. We might need a small fix there if it doesn't support forward. Let's just do rewind for now.

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
