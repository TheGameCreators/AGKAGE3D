attribute highp vec3 position;
attribute mediump vec3 normal;
varying highp vec3 posVarying;
varying mediump vec3 normalVarying;
varying mediump vec3 lightVarying;
mediump vec3 GetVSLighting( mediump vec3 normal, highp vec3 pos );

uniform highp mat3 agk_WorldNormal;
uniform highp mat4 agk_World;
uniform highp mat4 agk_ViewProj;
varying mediump vec3 tangentVarying;
varying mediump vec3 binormalVarying;
attribute highp vec2 uv;
attribute highp vec2 uv1;
varying highp vec2 uv0Varying;
varying highp vec2 uv1Varying;
uniform highp vec4 uvBounds0;
uniform highp vec4 uvBounds1;

void main()
{ 
    uv0Varying = uv * uvBounds0.xy + uvBounds0.zw;
    uv1Varying = uv1 * uvBounds1.xy + uvBounds1.zw;
    mediump vec3 tangent;
    if ( abs(normal.y) > 0.999 ) tangent = vec3( normal.y,0.0,0.0 );
    else tangent = normalize( vec3(-normal.z, 0.0, normal.x) );
    mediump vec3 binormal = normalize( vec3(normal.y*tangent.z, normal.z*tangent.x-normal.x*tangent.z, -normal.y*tangent.x) );
    highp vec4 pos = agk_World * vec4(position,1.0);
    gl_Position = agk_ViewProj * pos;
    mediump vec3 norm = normalize(agk_WorldNormal * normal);
    posVarying = pos.xyz;
    normalVarying = norm;
    lightVarying = GetVSLighting( norm, posVarying );
    tangentVarying = normalize(agk_WorldNormal * tangent);
    binormalVarying = normalize(agk_WorldNormal * binormal);
}

