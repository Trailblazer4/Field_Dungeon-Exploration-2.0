shader_type canvas_item;

uniform sampler2D noise_pattern;

// shader to make something look "fiery" in color
void fragment() {
	float timeChange = sin(TIME * 1.8) / 2.0;
	
	//float image_a = texture(TEXTURE, UV).a;
	vec4 base_color = texture(TEXTURE, UV);
	//base_color.a = image_a;
	float avg = (base_color.r + base_color.g + base_color.b) / 3.0;
	COLOR = vec4((timeChange + 1.7) * 0.9, (timeChange + (avg * 1.4)) * 0.5, avg * 0.38, base_color.a);
	// I'll work out the math sometime to see what colors can weave in and out based on time
	if(avg < 0.57){
		COLOR.g = avg * 0.65;
	}
}