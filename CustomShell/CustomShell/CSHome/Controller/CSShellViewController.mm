//
//  CSShellViewController.m
//  CustomShell
//
//  Created by guoyi on 16/6/20.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSShellViewController.h"

//  Model
#import "CSStlParser.h"

@interface CSShellViewController ()
{
    //  GL
    EAGLContext *_context;
    GLuint _buffer;
    GLKBaseEffect *_effect;
    float *_squareVertexData;
    int _faceNum;
    int _dataCount;
    GLKView *_glview;
    
}
@end

@implementation CSShellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tearDownGL];
    
    
    
    NSString *stlFilePath = [[NSBundle mainBundle] pathForResource:@"RevolvedModel" ofType:@"stl"];
    NSValue *stlValue = [CSStlParser stlWithFilePath:stlFilePath];
    
    NSLog(@"stlValue = %@", stlValue);
    
    struct pointInfo
    {
        float *squareVertexData;
        int   faceNum;
    };
    
    pointInfo pro;
    [stlValue getValue:&pro];
    
    _squareVertexData = pro.squareVertexData;
    _faceNum = pro.faceNum;
    [self renderUI:_squareVertexData];
    
}

#pragma mark - Private Methods

- (void)tearDownGL {
    [EAGLContext setCurrentContext:_context];
    glDeleteBuffers(1, &_buffer);
    _effect = nil;
}

#pragma mark ---渲染数据
- (void)renderUI:(float *)sqData {
    
    
    //一下大括号内代码为转换模型数据用于重新绘制模型合适大小至屏幕中心及
    {
        
        //定义出6个变量用于储存最小和最大的xyz
        float xMax = _squareVertexData[0];
        float yMax = _squareVertexData[1];
        float zMax = _squareVertexData[2];
        
        float xMin = _squareVertexData[0];
        float yMin = _squareVertexData[1];
        float zMin = _squareVertexData[2];
        
        
        
        NSLog(@"点个数:%d",_faceNum*24);
        //循环获取最小最大xyz
        for (int i=0; i<_faceNum*24; i++) {
            if ((i+1)%8 == 1) {
                
                if (_squareVertexData[i] > xMax) {
                    xMax = _squareVertexData[i];
                }
                
                if (_squareVertexData[i] < xMin)
                {
                    xMin = _squareVertexData[i];
                }
                
                
                
            }
            else if ((i+1)%8 == 2) {
                
                if (_squareVertexData[i] > yMax) {
                    yMax = _squareVertexData[i];
                }
                
                if (_squareVertexData[i] < yMin)
                {
                    yMin = _squareVertexData[i];
                }
                
                
            }
            else if ((i+1)%8 == 3) {
                
                
                if (_squareVertexData[i] > zMax) {
                    zMax = _squareVertexData[i];
                }
                
                if (_squareVertexData[i] < zMin)
                {
                    zMin = _squareVertexData[i];
                }
                
                
            }
            
            
            
        }
        
        
        NSLog(@"xyz最小：%f,%f,%f",xMin,yMin,zMin);
        NSLog(@"xyz最大：%f,%f,%f",xMax,yMax,zMax);
        
        NSLog(@"中心点坐标为:%f,%f,%f",(xMax-xMin)/2+xMin,(yMax-yMin)/2+yMin,(zMax-zMin)/2+zMin);
        
        
        
        //求出最长的长径
        float diameter = -200.0;
        
        if ((xMax-xMin)>=(yMax-yMin) && (xMax-xMin)>=(zMax - zMin)) {
            diameter = xMax-xMin;
        }
        if ((yMax-yMin)>=(xMax-xMin) && (yMax-yMin)>=(zMax - zMin)) {
            diameter = yMax-yMin;
        }
        if ((zMax-zMin)>=(yMax-yMin) && (xMax-xMin)<=(zMax - zMin)) {
            diameter = zMax-zMin;
        }
        
        NSLog(@"最长的长径：%f",diameter);
        
        //算出一个合适的比例展示模型
        float bili = 2.0/diameter;
        
        
        
        
        float midX,midY,midZ;
        midX =(xMax-xMin)/2+xMin;
        midY =(yMax-yMin)/2+yMin;
        midZ =(zMax-zMin)/2+zMin;
        
        
        
        
        for (int i=0; i<_faceNum*24; i++) {
            float tem = _squareVertexData[i];
            if ((i+1)%8 == 1) {
                _squareVertexData[i] = (tem - midX)*bili;
            }
            else if((i+1)%8 == 2)
            {
                _squareVertexData[i] = (tem - midY)*bili;
            }
            else if ((i+1)%8 == 3)
            {
                _squareVertexData[i] = (tem - midZ)*bili;
            }
            else
            {
                _squareVertexData[i] = tem;
            }
            
        }
        
        
    }
    
    
    
    _dataCount  = (int)(_faceNum*3);
    
    //用es2创建一个“EAGLContext”实例。
    _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //将“view”的context设置为这个“EAGLContext”实例的引用。并且设置颜色格式和深度格式
    
    _glview.context = _context;
    _glview.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    _glview.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    _glview.center = self.view.center;
    
    
    
    
    
    
    //将此“EAGLContext”实例设置为OpenGL的“当前激活”的“Context”。这样，以后所有“GL”的指令均作用在这个“Context”上。随后，发送第一个“GL”指令：激活“深度检测”。
    [EAGLContext setCurrentContext:_context];
    glEnable(GL_DEPTH_TEST);//激活深度检测
    
    
    
    
    
    
    //    顶点数组保存进缓冲区
    //vertex data
    
    glGenBuffers(1, &_buffer);
    glBindBuffer(GL_ARRAY_BUFFER, _buffer);
    glBufferData(GL_ARRAY_BUFFER, _faceNum*24*4, _squareVertexData, GL_STATIC_DRAW);
    
    
    
    //    3、将缓冲区的数据复制进通用顶点属性中
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 4*8, (char *)NULL + 0);  //读顶点坐标
    
    
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 4*8, (char *)NULL +12); //读法线
    
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4*8, (char *)NULL + 24);  //读纹理
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //创建一个GLK内置的“着色效果”，并给它提供一个光源，光的颜色为默认银灰色
    _effect = [[GLKBaseEffect alloc]init];
    _effect.light0.enabled = GL_TRUE;
    _effect.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);//漫反射颜色,依然按照rgb
    
    //     self.effect.light0.diffuseColor = GLKVector4Make(0.231, 0.247, 0.271, 1.0);//漫反射颜色,依然按照rgb
    //    self.effect.light0.specularColor  =  GLKVector4Make(0.361, 0.475, 0.749, 1.0);//高光颜色,依然按照rgb
    //    self.effect.light0.ambientColor  =  GLKVector4Make(0.620, 0.761, 0.055, 1.0);//环境光颜色,依然按照rgb
    
    
    
    
    //    2、将纹理坐标原点改为左下角
    //    GLKit加载纹理，默认都是把坐标设置在“左上角”。然而，OpenGL的纹理贴图坐标却是在左下角，这样刚好颠倒。
    //    在加载纹理之前，添加一个“options”：
    
    //        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Tulips" ofType:@"JPG"];
    //
    //        NSDictionary *options = [NSDictionary  dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil];
    //        GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //        self.effect.texture2d0.enabled = GL_TRUE;
    //        self.effect.texture2d0.name = textureInfo.name;
    //    这个参数可以让系统在加载纹理后，做一些基本的处理。如预乘Alpha、创建“Mipmaps”等。
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    
    
    glClearColor(131/255.0, 166/255.0, 205/255.0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    [_effect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, _dataCount); //有几行数据，最后一个参数就是多少
    
    
    
    
    //    前两行为渲染前的“清除”操作，清除颜色缓冲区和深度缓冲区中的内容，并且填充淡蓝色背景（默认背景是黑色）。
    //    “prepareToDraw”方法，是让“效果Effect”针对当前“Context”的状态进行一些配置，它始终把“GL_TEXTURE_PROGRAM”状态定位到“Effect”对象的着色器上。此外，如果Effect使用了纹理，它也会修改“GL_TEXTURE_BINDING_2D”。
    //    接下来，用“glDrawArrays”指令，让OpenGL“画出”两个三角形（拼合为一个正方形）。OpenGL会自动从通用顶点属性中取出这些数据、组装、再用“Effect”内置的着色器渲染。
    
    
    
}

@end
