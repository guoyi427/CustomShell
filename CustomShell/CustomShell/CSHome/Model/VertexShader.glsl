attribute vec4 position;
uniform mat4 projection;
uniform mat4 modelView;
varying vec4 fragmentColor;

uniform mat3 normalMatrix;
uniform vec3 vLightPosition;
//环境光
uniform vec4 vAmbientMaterial;
//反射光
uniform vec4 vSpecularMaterial;
uniform float shininess;

//法线
attribute vec3 vNormal;
//漫反射
attribute vec4 vDiffuseMaterial;

void main(void) {
    gl_Position = projection * modelView * position;
    
    vec3 N = normalMatrix * vNormal;
    vec3 L = normalize(vLightPosition);
    vec3 E = vec3(0, 0, 1);
    vec3 H = normalize(L + E);

    float df = max(0.0, dot(N, L));
    float sf = max(0.0, dot(N, H));
    sf = pow(sf, shininess);
    
    fragmentColor = vAmbientMaterial + df * vDiffuseMaterial + sf * vSpecularMaterial;
}