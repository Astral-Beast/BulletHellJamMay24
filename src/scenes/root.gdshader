shader_type canvas_item;
uniform sampler2D Glow_Map;

void vertex() { 
	
	UV.y -= TIME; 
	
}

void fragment() {
	vec4 glow_color = texture(Glow_Map, vec2(UV.x, UV.y+TIME));
	//COLOR = glow_color;
	if (COLOR.g > COLOR.r){
		COLOR = vec4(COLOR.r, COLOR.g+50.0, COLOR.b, 1.0);
	}
}