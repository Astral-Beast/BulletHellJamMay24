shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float x_diff = distance( UV,vec2(0.5));
	if (x_diff > .4 && x_diff < .5) {
		COLOR = vec4(0);
	}
	else if ( x_diff > .4 ) {
	vec3 color = vec3(0.0, 80., 100);
		COLOR = vec4(color, .95);
	
	}
	else {
		vec3 color = vec3(100, 0.0, 100);
		COLOR = vec4(color, .95);
	}

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
