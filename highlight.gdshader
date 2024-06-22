shader_type canvas_item;
uniform float speed: hint_range(1.0, 5.0, 0.1) = 4.0;
uniform float max_white: hint_range(0.0, 1.0, 0.01) = 0.08;

void fragment() {
	COLOR = mix(COLOR, vec4(1.0, 1.0, 1.0, COLOR.a), max_white * (sin(TIME * speed) + 1.0)); // fluctuates mix with white between 0% and 40%
}