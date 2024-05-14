shader_type canvas_item;


float SineWave(float x, float t)
{
    // Sine wave
    const float height = .2; // UV %
    const float sineWidth = 1.0; // Go to the edge of the UV
    const float pi = 3.1415;
    
    if(x < 0.0 || x > sineWidth) 
        return 0.0;
    else
    	return sin(x*t*pi/sineWidth) * height;
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//Called for every pixel the material is visible on.
	if (UV.y-.15> SineWave(UV.x, TIME)){
	COLOR = vec4(UV.x,UV.y,sin(UV.x-UV.y), 1);
	} else {
		COLOR = vec4(0,0,0,0);
	}


}



//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
