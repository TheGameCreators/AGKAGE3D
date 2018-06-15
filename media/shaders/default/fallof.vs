/*
Rim lighting vertex shader
Written by TheSnidr
www.thesnidr.com
*/
/*
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)
attribute vec3 in_Normal;                    // (x,y,z)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying float dp;
*/

attribute vec3 position;
attribute vec2 uv;
attribute vec3 normal;

uniform mat4 agk_WorldViewProj;
uniform mat4 agk_World;
uniform mat4 agk_ViewProj;
uniform mat4 agk_View;
uniform mat4 agk_Proj;
uniform mat3 agk_WorldNormal;
uniform vec4 agk_MeshDiffuse;
uniform vec4 uvBounds0;

varying vec2 uv0Varying;
varying float dp;
varying vec4 colorVarying;
varying vec3 posVarying;




void main()
{
    // gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4( in_Position, 1.0);
	// gl_Position = agk_WorldViewProj * vec4( Position, 1.0);

    //v_vColour = in_Colour;
    //v_vTexcoord = in_TextureCoord;
    //posVarying = Position.xyz;	
	//colorVarying = agk_MeshDiffuse;
	
	
	uv0Varying = uv * uvBounds0.xy + uvBounds0.zw;

	highp vec4 pos = agk_World * vec4(position,1.0);
	gl_Position = agk_ViewProj * pos;  

	
	
    //vec3 wvPosition = normalize((gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Position, 1.0)).xyz);
	//vec3 norm = normalize(normalVarying);
	mediump vec3 norm = normalize(agk_WorldNormal * normal);
	 
	 
	vec3 wvPosition = normalize((agk_WorldViewProj * vec4(position, 1.0)).xyz); 
	//vec3 wvPosition = normalize((agk_View * vec4(position, 1.0)).xyz);

    //vec3 wvNormal = normalize((gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Normal, 0.0)).xyz);
    //vec3 wvNormal = normalize((agk_World * vec4(normal, 0.0)).xyz);
    vec3 wvNormal = normalize((agk_View * vec4(normal, 0.0)).xyz);
	
	
	
    float power = 2.0; //Increase to reduce the effect or decrease to increase the effect
    // dp = pow(dot(wvPosition, wvNormal)+1.0, power);
    dp = pow(dot(wvPosition, wvNormal)+1.0, power);
	
}