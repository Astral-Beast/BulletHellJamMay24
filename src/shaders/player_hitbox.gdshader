shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float dist = distance(UV, vec2(.5));
	if (dist <=.4){
		COLOR = vec4(1,.2,.5,1);
	} else if (dist <=.5){
		COLOR = vec4(0,0,1,1);
	} else{
		COLOR = vec4(0);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
