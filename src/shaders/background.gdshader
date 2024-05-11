shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR =COLOR;
	// Called for every pixel the material is visible on.
	//if (COLOR.a <.01) {
    ////Variables
    //float col = 10.0;
    //float thickness = 1.5;
    //float antialiasing = 0.001;
    //float intensity = 1.0;
    //float speed = .03;
    //vec2 offset = vec2(1,1);
   	//vec4 color = vec4(1.0,0.0,1.0,1.0);
    //
    //vec2 uv = (UV/SCREEN_PIXEL_SIZE.x)*col;
	//
    ////offset animation
	//vec2 next = vec2(offset.x, TIME*speed);
    //uv += next;
	//
    ////grid
    //vec2 grep = abs(fract(uv) - 0.5);
    //float grid = max(grep.x,grep.y)*thickness;
	//
    ////antialiasing
	//
	//color *= smoothstep(0.48,0.49,grid);
//
	//COLOR = vec4(color*intensity);
//}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
