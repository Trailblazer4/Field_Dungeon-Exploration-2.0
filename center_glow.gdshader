shader_type canvas_item;
uniform float offset_x: hint_range(0.0, 1.0, 0.01) = 0.12;
uniform float offset_y: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float stretch_x: hint_range(0.0, 2.0, 0.01) = 1.5;
uniform float stretch_y: hint_range(0.0, 2.0, 0.01) = 0.5; // 0.31
uniform float brightness: hint_range(0.1, 10.0, 0.01) = 5.16;
uniform float redness: hint_range(0.1, 1.0, 0.01) = 0.86;
uniform float whiteness: hint_range(0.1, 3.0, 0.01) = 1.8;

void fragment() {
	// set pixel to yellow;
	COLOR = vec4(redness, 1.0, 1.0, COLOR.a);
	// then, decrease green value while reaching edge
	//COLOR.g -= (abs(UV.x - offset_x) / 0.2 + sqrt(0.25 - (UV.x * UV.x)) * 0.10); // / brightness;
	//COLOR.b -= (abs(UV.x - offset_x) / 0.2 + sqrt(0.25 - (UV.x * UV.x)) * 0.01); // / brightness * 4.0;
	//COLOR.g -= sqrt(stretch_x * (abs(UV.x - offset_x) * abs(UV.x - offset_x)) + stretch_y * (abs(UV.y - offset_y) * abs(UV.y - offset_y))) * brightness;
	//COLOR.b -= sqrt(stretch_x * (abs(UV.x - offset_x) * abs(UV.x - offset_x)) + stretch_y * (abs(UV.y - offset_y) * abs(UV.y - offset_y))) * brightness * 1.8;
	float center_x = abs(UV.x - offset_x) * abs(UV.x - offset_x);
	float center_y = abs(UV.y - offset_y) * abs(UV.y - offset_y);
	float color_vector = sqrt((stretch_x * center_x) + (stretch_y * center_y)) * brightness;

	COLOR.g -= color_vector;
	COLOR.b -= color_vector * whiteness;
}

// y = sqrt(0.25 - x^2)

// COLOR.g -= sqrt(x^2 + y^2)
// COLOR.g -= sqrt((abs(UV.x - 0.5) * abs(UV.x - 0.5)) + (abs(UV.y - 0.5) * abs(UV.x - 0.5)))

// if (abs(UV.x - 0.5)^2 + abs(UV.y - 0.5)^2 > 0.5){subtract 1}