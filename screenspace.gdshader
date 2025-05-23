shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = COLOR * 16.0;
	COLOR.r = floor(COLOR.r) / 16.0;
	COLOR.g = floor(COLOR.g) / 16.0;
	COLOR.b = floor(COLOR.b) / 16.0;
}