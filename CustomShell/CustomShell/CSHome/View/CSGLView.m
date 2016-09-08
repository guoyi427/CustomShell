//
//  CSGLView.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/8.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSGLView.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "ksMatrix.h"
#import "ZLCStlparser.h"

struct STL_VertexInfo {
    float *vertices;
    int faceCount;
};

@interface CSGLView ()
{
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    GLuint _programHandle;
    GLuint _positionSlot;
    GLuint _projectionSlot;
    GLuint _modelViewSlot;
    ksMatrix4 _projectionMatrix;
    ksMatrix4 _modelViewMatrix;
    CGPoint _rotatePoint;
    CGPoint _touchBeganPoint;
    
    NSString *_stlPath;
    float *_stl_vertices;
    int _faceCount;
}
@end

@implementation CSGLView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _prepareLayer];
        [self _prepareContext];
        [self _prepareBuffers];
        [self _prepareProgram];
        [self _prepareProjection];
        
        [self _updateModelView];
//        [self render];
    }
    return self;
}

#pragma mark - Prepare

- (void)_prepareLayer {
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties = @{
                                      kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
                                      kEAGLDrawablePropertyRetainedBacking : @NO
                                      };
}

- (void)_prepareContext {
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_context];
}

- (void)_prepareBuffers {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)_prepareProgram {
    GLuint vertexShader = [self loadShaderType:GL_VERTEX_SHADER name:@"VertexShader"];
    GLuint fragmentShader = [self loadShaderType:GL_FRAGMENT_SHADER name:@"FragmentShader"];
    if (!vertexShader) {
        NSLog(@"Error: Load VertexShader Faild");
        exit(1);
    }
    if (!fragmentShader) {
        NSLog(@"Error: Load FragmentShader Faild");
        exit(1);
    }
    _programHandle = glCreateProgram();
    glAttachShader(_programHandle, vertexShader);
    glAttachShader(_programHandle, fragmentShader);
    glLinkProgram(_programHandle);
    
    //  check
    GLint linkStatus;
    glGetProgramiv(_programHandle, GL_LINK_STATUS, &linkStatus);
    if (!linkStatus) {
        NSLog(@"Error: Link Program Faild");
        GLint infolen;
        glGetProgramiv(_programHandle, GL_INFO_LOG_LENGTH, &infolen);
        if (infolen) {
            char *infoLog = malloc(sizeof(char)*infolen);
            glGetProgramInfoLog(_programHandle, infolen, nil, infoLog);
            NSLog(@"Error: Link Faild Info %s", infoLog);
            free(infoLog);
        }
        exit(1);
    }
    
    _positionSlot = glGetAttribLocation(_programHandle, "position");
    _projectionSlot = glGetUniformLocation(_programHandle, "projection");
    _modelViewSlot = glGetUniformLocation(_programHandle, "modelView");
    
    glUseProgram(_programHandle);
}

- (GLuint)loadShaderType:(GLenum)type name:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"glsl"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:path
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (!shaderString) {
        NSLog(@"Error: Load Shader %@ Faild %@", name, error.localizedDescription);
        exit(1);
    }
    
    const char *shaderUTF8 = [shaderString UTF8String];
    GLuint shaderHandle = glCreateShader(type);
    glShaderSource(shaderHandle, 1, &shaderUTF8, nil);
    glCompileShader(shaderHandle);
    
    //  check
    GLint compileStatus;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileStatus);
    if (!compileStatus) {
        NSLog(@"Error: Compile Shader %@ Faild", name);
        GLint infoLen;
        glGetShaderiv(shaderHandle, GL_INFO_LOG_LENGTH, &infoLen);
        if (!infoLen) {
            char *infoLog = malloc(sizeof(char) * infoLen);
            NSLog(@"Error: Compile Shader %@ Fiald %s", name, infoLog);
            free(infoLog);
        }
        exit(1);
    }
    return shaderHandle;
}

- (void)_prepareProjection {
    ksMatrixLoadIdentity(&_projectionMatrix);
    ksPerspective(&_projectionMatrix, 60, CGRectGetWidth(self.frame)/CGRectGetHeight(self.frame), 1, 20);
    
    glUniformMatrix4fv(_projectionSlot, 1, GL_FALSE, &_projectionMatrix.m[0][0]);
    glEnable(GL_CULL_FACE);
}

- (void)_updateModelView {
    ksMatrixLoadIdentity(&_modelViewMatrix);
    ksMatrixTranslate(&_modelViewMatrix, 0, 0, -3);
    ksMatrixRotate(&_modelViewMatrix, _rotatePoint.x, 0, -1, 0);
    ksMatrixRotate(&_modelViewMatrix, _rotatePoint.y, -1, 0, 0);
    
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, &_modelViewMatrix.m[0][0]);
}

- (void)renderStlWithPath:(NSString *)path {
    glClearColor(0, 0.6, 0.5, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    [self _prepareStlWithPath:path];
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(float)*8, _stl_vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    glDrawArrays(GL_TRIANGLES, 0, _faceCount * 3);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)_prepareStlWithPath:(NSString *)path {
    _stlPath = path;
    NSValue *stlValue = [ZLCStlparser ParserStlFileWithfilaPath:path];
    struct STL_VertexInfo info;
    [stlValue getValue:&info];
    
    _stl_vertices = info.vertices;
    _faceCount = info.faceCount;
    
    [ZLCStlparser scaleVertices:_stl_vertices count:_faceCount];
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchBeganPoint = [touches.anyObject locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self];
    _rotatePoint = CGPointMake(point.x - _touchBeganPoint.x, point.y - _touchBeganPoint.y);
    
    [self _updateModelView];
    [self renderStlWithPath:_stlPath];
}

@end
