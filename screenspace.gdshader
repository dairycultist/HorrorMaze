shader_type canvas_item;

void fragment() {

	// maintains the horizontal amount of pixels
	vec2 fac = 480.0 * vec2(1.0, SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y);

	vec2 grid_uv = round(UV * fac) / fac;

	vec4 text = texture(TEXTURE, grid_uv);

	COLOR = text;

	COLOR = COLOR * 16.0;
	COLOR.r = floor(COLOR.r) / 16.0;
	COLOR.g = floor(COLOR.g) / 16.0;
	COLOR.b = floor(COLOR.b) / 16.0;
}