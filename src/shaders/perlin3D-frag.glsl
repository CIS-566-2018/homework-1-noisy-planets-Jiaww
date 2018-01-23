#version 300 es

#define SUMMED

// This is a fragment shader. If you've opened this file first, please
// open and read lambert.vert.glsl before reading on.
// Unlike the vertex shader, the fragment shader actually does compute
// the shading of geometry. For every pixel in your program's output
// screen, the fragment shader is run for every bit of geometry that
// particular pixel overlaps. By implicitly interpolating the position
// data passed into the fragment shader by the vertex shader, the fragment shader
// can compute what color to apply to its pixel based on things like vertex
// position, light position, and vertex color.
precision highp float;

uniform vec4 u_Color; // The color with which to render this instance of geometry.
uniform vec4 u_Color2; // The color with which to render this instance of geometry.
uniform float u_Time; // The color with which to render this instance of geometry.
uniform float u_Octave;
uniform float u_Trig;
uniform float u_FloatSpeed;

// These are the interpolated values out of the rasterizer, so you can't know
// their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;
in vec4 fs_Pos;
in float fs_Noise;
in float fs_Noise2;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.

void main()
{
    // Material base color (before shading)
    vec4 diffuseColor;
    vec4 color1 = u_Color, color2 = u_Color2;
    // Calculate the diffuse term for Lambert shading
    float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
    // Avoid negative lighting values
    diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);
    float ambientTerm = 0.2;

    float lightIntensity = diffuseTerm + ambientTerm;   //Add a small float value to the color multiplier
                                                        //to simulate ambient lighting. This ensures that faces that are not
                                                        //lit by our point light are not completely black.

    // Compute final shaded color
    //out_Col = vec4(diffuseColor.rgb * lightIntensity, diffuseColor.a);
    float interp = clamp(fs_Noise / 0.05, 0.0, 1.0);
    if (fs_Pos.y > 0.80 || fs_Pos.y < -0.80){
        // Polar
        float t = ((abs(fs_Pos.y)-0.8)/0.2) + fs_Noise2;
        color2 = vec4(0.9, 0.95, 0.95, 1.0) * t + u_Color2 * (1.0-t); 
    }
    diffuseColor = color1 * interp + color2 * (1.0 - interp);
    out_Col = vec4(diffuseColor.rgb * lightIntensity, diffuseColor.a);
    // out_Col = vec4(vec3(noise), 1.0);
}
