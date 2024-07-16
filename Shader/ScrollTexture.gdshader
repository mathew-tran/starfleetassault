shader_type canvas_item;

uniform float scroll_speed_x : hint_range(-10.0, 10.0);
uniform float scroll_speed_y : hint_range(-10.0, 10.0);
uniform float time : hint_range(0.0, 100.0);

void fragment() {
	vec2 uv = UV;

	uv.x += scroll_speed_x * TIME;
	uv.y += scroll_speed_y * TIME;

	uv = fract(uv);

	COLOR = texture(TEXTURE, uv);
}
//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
