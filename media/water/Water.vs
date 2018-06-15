//**** vertex shader
attribute vec3 position;
attribute vec3 normal;
attribute vec2 uv;

varying highp vec3 posVarying;
varying mediump vec3 normalVarying;
varying mediump vec2 uvVarying;
varying mediump vec3 lightVarying;
varying mediump vec3 colorVarying;

varying highp vec4 clipSpace;
varying highp vec3 cameraVector;

uniform vec4 uvBounds0;

// this must appear exactly as it is for it to work, spaces and all.
// it will be filled in by AGK
mediump vec3 GetVSLighting( mediump vec3 normal, highp vec3 pos );


uniform mat4 agk_World;
uniform mat4 agk_ViewProj;
uniform mat4 agk_View;
uniform mat3 agk_WorldNormal;

uniform vec3 cameraPosition;

void main()
{
	vec4 pos = agk_World * vec4(position, 1.0);
	
	clipSpace = agk_ViewProj * pos;
	cameraVector = cameraPosition - pos.xyz;
	gl_Position = clipSpace;
	
	vec3 norm = agk_WorldNormal * normal;
	posVarying = pos.xyz;
	normalVarying = norm;
	uvVarying = uv * uvBounds0.xy + uvBounds0.zw * 60.0;
	lightVarying = GetVSLighting( norm, posVarying );
}