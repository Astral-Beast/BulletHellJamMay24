shader_type canvas_item;
uniform sampler2D Glow_Map;

void vertex() { 
	
	UV.y -= TIME; 
	
}

void fragment() {
	vec4 glow_color = texture(Glow_Map, UV);

	COLOR = vec4(COLOR.r, COLOR.g+50.0*glow_color.g, COLOR.b, 1.0);

}