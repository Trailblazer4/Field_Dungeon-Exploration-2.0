shader_type canvas_item;

uniform sampler2D noise_pattern: repeat_enable;
uniform sampler2D fire_gradient;

void fragment() {
	// vec2 uv1 = vec2(UV.x, UV.y + (TIME * 0.25));
	// vec2 uv2 = vec2(UV.x - (TIME * 0.3), UV.y);
	
	// COLOR.rgb = texture(noise_pattern, uv1).rgb;
	// COLOR.a = texture(TEXTURE, UV).a;
	
	float tex_alpha = texture(TEXTURE, UV).a;
	float pattern_intensity = texture(noise_pattern, UV + TIME * vec2(0.12, 0.12)).r;
	float pattern_intensity2 = texture(noise_pattern, UV + TIME * vec2(0.1, 0.1)).r;
	float intensity = tex_alpha * pattern_intensity * pattern_intensity2;
	COLOR.rgb = texture(fire_gradient, vec2(intensity)).rgb;
}
