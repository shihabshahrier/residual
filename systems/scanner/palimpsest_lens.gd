class_name PalimpsestLens
extends ColorRect

## Handles the visual lens for the Palimpsest scanner, driving the SubViewport 
## and passing its texture to the shader.

@export var vestige_viewport: SubViewport
@export var scan_radius: float = 0.3
@export var scan_center: Vector2 = Vector2(0.5, 0.5)

var _material: ShaderMaterial

func _ready() -> void:
	if material is ShaderMaterial:
		_material = material as ShaderMaterial
	else:
		push_warning("PalimpsestLens requires a ShaderMaterial with palimpsest_scanner.gdshader")

func _process(_delta: float) -> void:
	if not _material:
		return
		
	_material.set_shader_parameter("scan_radius", scan_radius)
	_material.set_shader_parameter("scan_center", scan_center)
	
	if vestige_viewport != null:
		_material.set_shader_parameter("vestige_texture", vestige_viewport.get_texture())
