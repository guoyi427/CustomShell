attribute vec4 position;
uniform mat4 projection;
uniform mat4 modelView;
varying vec4 fragmentColor;

void main(void) {
    gl_Position = projection * modelView * position;
    fragmentColor = vec4(position[0], position[1], position[2], 1);
}