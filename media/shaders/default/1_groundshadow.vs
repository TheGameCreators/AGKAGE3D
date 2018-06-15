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
varying highp vec2 uv1Varying;
uniform highp vec4 uvBounds0;
uniform highp vec4 uvBounds1;

void main()
{ 
    uvVarying = uv * uvBounds0.xy + uvBounds0.zw;
    uv1Varying = uv * uvBounds1.xy + uvBounds1.zw;
    highp vec4 pos = agk_World * vec4(position,1.0);
    gl_Position = agk_ViewProj * pos;
    mediump vec3 norm = normalize(agk_WorldNormal * normal);
    posVarying = pos.xyz;
    normalVarying = norm;
    lightVarying = GetVSLighting( norm, posVarying );
}
