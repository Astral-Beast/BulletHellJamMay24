shader_type canvas_item;
uniform sampler2D Glow_Map;

void vertex() { 
	
	UV.y -= TIME; 
	
}

void fragment() {
	
	if (COLOR.g > COLOR.r){
		COLOR = vec4(COLOR.r, COLOR.g+50.0, COLOR.b, 1.0);
	}
}