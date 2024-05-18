shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (COLOR.a > 0.0){
		//float r = clamp(sin(distance(UV, vec2(0))*TIME/20.), .6,.9);
		//float g = clamp(sin(TIME*UV.y), .7,1.0);
		//float b = sin(UV.x/2.0);
		//COLOR = vec4(r+7.0, g+7.0, .7,50.0);
		COLOR = vec4(.2, 1, 0.55, 1);
	}
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
