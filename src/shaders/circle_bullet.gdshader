shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float x_diff = distance( UV,vec2(0.5));
	if (x_diff > .4) {
		COLOR = vec4(0);
	}
	else {
		COLOR = vec4(0.0, 80., 100, .95);
	
	}

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
