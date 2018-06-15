// vs
attribute highp vec3 position;
attribute mediump vec3 normal;
varying highp vec3 posVarying;
varying mediump vec3 normalVarying;
varying mediump vec3 lightVarying;
mediump vec3 GetVSLighting( mediump vec3 normal, highp vec3 pos );

uniform highp mat4 agk_WorldViewProj;
uniform highp mat3 agk_WorldNormal;
uniform highp mat4 agk_World;
uniform highp mat4 agk_ViewProj;
attribute highp vec2 uv;
varying highp vec2 uvVarying;
uniform highp vec4 uvBounds0;
varying highp vec2 uvNormal;

void main()
{ 
    uvVarying = uv * uvBounds0.xy + uvBounds0.zw;
    highp vec4 pos = agk_World * vec4(position,1.0);
    gl_Position = agk_ViewProj * pos;
    mediump vec3 norm = normalize(agk_WorldNormal * normal);
    posVarying = pos.xyz;
    normalVarying = norm;
	uvNormal = -normalize((agk_WorldViewProj * vec4(normal, 0.0)).xyz).xy*0.3+0.50; // normal
    lightVarying = GetVSLighting( norm, posVarying );
}
