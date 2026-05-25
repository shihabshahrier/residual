shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D texture_albedo : source_color, filter_nearest, repeat_disable;
uniform vec4 key_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tolerance : hint_range(0.0, 1.0) = 0.2;

void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	
	// Distance between current pixel color and key color
	float diff = distance(albedo_tex.rgb, key_color.rgb);
	
	if (diff < tolerance) {
		discard; // Throw away white background pixels
	}
	
	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a;
}
