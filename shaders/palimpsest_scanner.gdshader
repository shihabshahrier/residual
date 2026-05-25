shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform sampler2D vestige_texture : filter_nearest; // Rendered output from SubViewport
uniform float scan_radius = 0.3;
uniform vec2 scan_center = vec2(0.5, 0.5);
uniform float noise_amount = 0.05;
uniform float chromatic_aberration = 0.01;
uniform vec4 scan_color : source_color = vec4(0.0, 1.0, 1.0, 1.0); // Memory cyan

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Calculate soft radial mask based on scanner position
    float dist = distance(uv, scan_center);
    float mask = smoothstep(scan_radius, scan_radius - 0.05, dist);
    
    if (mask > 0.0) {
        // Temporal noise
        float noise = rand(uv + vec2(TIME)) * noise_amount;
        
        // Chromatic aberration specifically on the vestige layer
        vec4 vestige_raw = texture(vestige_texture, uv);
        float r = texture(vestige_texture, uv + vec2(chromatic_aberration, 0.0)).r;
        float g = vestige_raw.g;
        float b = texture(vestige_texture, uv - vec2(chromatic_aberration, 0.0)).b;
        vec4 vestige_color = vec4(r, g, b, vestige_raw.a);
        
        // Scanlines distortion
        float scanline = sin(uv.y * 800.0 - TIME * 10.0) * 0.04;
        
        vec3 final_vestige = vestige_color.rgb + scanline + noise;
        
        // Tint vestiges with the memory color
        final_vestige *= scan_color.rgb;
        
        // Base screen color
        vec4 original = texture(screen_texture, uv);
        
        // Blend: Where vestige alpha is high, show vestige. Otherwise, show original with a slight tint.
        float v_alpha = vestige_color.a;
        vec3 blended_rgb = mix(original.rgb, final_vestige, v_alpha * mask);
        
        COLOR = vec4(blended_rgb, original.a);
    } else {
        COLOR = texture(screen_texture, uv);
    }
}
