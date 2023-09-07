shader_type spatial;
render_mode depth_draw_opaque, cull_disabled;

uniform float fov : hint_range(20, 120) = 45;

void vertex() {
	// Viewmodel fov
	PROJECTION_MATRIX[0][0] - (1.0 / tan(fov * 0.5 * PI / 180.0)) / (VIEWPORT_SIZE.x / VIEWPORT_SIZE.y);
}

void fragment() {
	// Handle rendering on top
	DEPTH = FRAGCOORD.z * 0.7;
}