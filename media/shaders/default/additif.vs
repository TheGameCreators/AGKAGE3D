attribute vec3 position;
attribute vec2 uv;
varying vec2 uvVarying;
varying vec3 posVarying;
uniform mat4 agk_World;
uniform mat4 agk_ViewProj;
uniform vec4 agk_MeshDiffuse;
uniform vec4 uvBounds0;

void main()
{ 
	vec4 pos = agk_World * vec4(position,1.0);
	gl_Position = agk_ViewProj * pos;
	posVarying = position.xyz;
	uvVarying = uv * uvBounds0.xy + uvBounds0.zw;
}