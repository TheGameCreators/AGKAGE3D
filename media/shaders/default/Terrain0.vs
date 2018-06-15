// terrain with 2 textures  for ground and an alpha for the road
attribute highp vec3 position;
attribute vec2 uv;
attribute mediump vec3 normal;
varying highp vec3 posVarying;
varying mediump vec3 normalVarying;
varying mediump vec3 lightVarying;
mediump vec3 GetVSLighting( mediump vec3 normal, highp vec3 pos );

varying vec2 uv0Varying;
varying vec2 uv1Varying;
varying vec2 uv2Varying;
uniform vec4 uvBounds0;
uniform vec4 uvBounds1;
uniform vec4 uvBounds2;
  
uniform highp mat4 agk_WorldViewProj;
uniform highp mat3 agk_WorldNormal;
uniform highp mat4 agk_World;
uniform highp mat4 agk_ViewProj;
 
void main()
{

	highp vec4 pos = agk_World * vec4(position,1.0);
    gl_Position = agk_ViewProj * pos;
    mediump vec3 norm = normalize(agk_WorldNormal * normal);
    posVarying = pos.xyz;
    normalVarying = norm;
    lightVarying = GetVSLighting( norm, posVarying );
	
	// TEXTURES COORDS	
    uv0Varying = uv * uvBounds0.xy + uvBounds0.zw;
    uv1Varying = uv * uvBounds1.xy + uvBounds1.zw;
    uv2Varying = uv * uvBounds2.xy + uvBounds2.zw;
}