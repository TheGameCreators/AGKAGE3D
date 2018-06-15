// vs
attribute highp vec3 position;
attribute mediump vec3 normal;
varying highp vec3 posVarying;

uniform highp mat4 agk_WorldViewProj;
uniform highp mat3 agk_WorldNormal;
uniform highp mat4 agk_World;
uniform highp mat4 agk_ViewProj;
attribute highp vec2 uv;
varying highp vec2 uvVarying;
uniform highp vec4 uvBounds0;

void main()
{ 
    uvVarying = uv * uvBounds0.xy + uvBounds0.zw;
    highp vec4 pos = agk_World * vec4(position,1.0);
    gl_Position = agk_ViewProj * pos;
    posVarying = pos.xyz;
}
