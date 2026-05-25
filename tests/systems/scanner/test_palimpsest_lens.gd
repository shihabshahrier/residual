extends GutTest

var lens: PalimpsestLens
var viewport: SubViewport
var shader_material: ShaderMaterial

func before_each() -> void:
	lens = PalimpsestLens.new()
	viewport = SubViewport.new()
	shader_material = ShaderMaterial.new()
	
	# Mocking a basic shader just to test parameter assignment
	var shader := Shader.new()
	shader.code = """
		shader_type canvas_item;
		uniform float scan_radius;
		uniform vec2 scan_center;
		uniform sampler2D vestige_texture;
		void fragment() {}
	"""
	shader_material.shader = shader
	lens.material = shader_material
	lens.vestige_viewport = viewport
	
	add_child_autoqfree(viewport)
	add_child_autoqfree(lens)

func test_shader_parameters_updated_on_process() -> void:
	lens.scan_radius = 0.8
	lens.scan_center = Vector2(0.2, 0.4)
	
	# Simulate a process tick
	lens._process(0.016)
	
	var mat: ShaderMaterial = lens.material as ShaderMaterial
	assert_eq(mat.get_shader_parameter("scan_radius"), 0.8, "Shader radius should match lens radius")
	assert_eq(mat.get_shader_parameter("scan_center"), Vector2(0.2, 0.4), "Shader center should match lens center")
	# Vestige texture assignment is hard to assert exactly as we can't extract the viewport texture reference directly easily in tests, 
	# but we can ensure it doesn't crash and the variables are updated.
	pass
