#pragma header
uniform float Threshold; // Default is 0.3
uniform float Intensity; // Default is 0.0

//https://www.shadertoy.com/view/ctffR8

vec4 blend(in vec2 Coord, in sampler2D Tex, in float MipBias)
{
	vec2 TexelSize = MipBias/openfl_TextureSize.xy;

	vec4 Color = vec4(0.0, 0.0, 0.0, 1.0);//flixel_texture2D(Tex, Coord);
    
    // Take 6 samples from the texture (Thanks to Envy24 for optimizing)
    for (float i = 1.; i <= 12.; i += 1.)
    {
        float inv = 1./i;
        Color += flixel_texture2D(Tex, Coord + vec2( TexelSize.x, TexelSize.y)*inv);
        Color += flixel_texture2D(Tex, Coord + vec2(-TexelSize.x, TexelSize.y)*inv);
        Color += flixel_texture2D(Tex, Coord + vec2( TexelSize.x,-TexelSize.y)*inv);
        Color += flixel_texture2D(Tex, Coord + vec2(-TexelSize.x,-TexelSize.y)*inv);
    }
	

	return Color/48.0;
}

void main()
{
	vec2 uv = openfl_TextureCoordv;

	vec4 Color = flixel_texture2D(bitmap, uv);

	vec4 Highlight = clamp(blend(uv, bitmap, 96.0)-Threshold,0.0,1.0)*1.0/(1.0-Threshold);


    gl_FragColor = Color + (Highlight * Intensity);
    gl_FragColor.rgb = pow(gl_FragColor.rgb, vec3(1.0));

}