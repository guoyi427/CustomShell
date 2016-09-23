//
//  CSGameViewController.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/18.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSGameViewController.h"

@interface CSGameViewController ()
{
    //  Data
    CGPoint _touchBeganPoint;
    
    //  Scene
    SCNScene *_scene;
    SCNView *_gameView;
    SCNNode *_cameraNode;
}
@end
@implementation CSGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _prepareScene];
    [self _prepareFloor];
    [self _prepareWall];
//    [self _prepareOtherNode];
//    [self _prepareCubeNode];
}

#pragma mark - Prepare

- (void)_prepareScene {
    _scene = [SCNScene scene];
    
    _cameraNode = [SCNNode node];
    _cameraNode.camera = [SCNCamera camera];
    _cameraNode.position = SCNVector3Make(0, 170, 10);
    _cameraNode.camera.zFar = 4000;
    [_scene.rootNode addChildNode:_cameraNode];
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(100, 100, 100);
    [_scene.rootNode addChildNode:lightNode];
    
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor grayColor];
    [_scene.rootNode addChildNode:ambientLightNode];
    
    _gameView = [[SCNView alloc] initWithFrame:self.view.bounds];
    _gameView.scene = _scene;
    _gameView.backgroundColor = [UIColor blackColor];
    _gameView.showsStatistics = YES;
//    _gameView.allowsCameraControl = YES;
    [self.view addSubview:_gameView];
}

- (void)_prepareFloor {
    SCNFloor *floor = [SCNFloor floor];
    floor.reflectivity = 0;
    
    SCNNode *floorNode = [SCNNode nodeWithGeometry:floor];
    [_scene.rootNode addChildNode:floorNode];
    
    SCNMaterial *material = [SCNMaterial material];
    material.litPerPixel = NO;
    material.diffuse.contents = [UIImage imageNamed:@"ground"];
    material.diffuse.wrapS = SCNWrapModeRepeat;
    material.diffuse.wrapT = SCNWrapModeRepeat;
    
    floor.materials = @[material];
}

- (void)_prepareWall {
    
    float height = 280;
    float depth = 36;
    float width = 808;
    float length = 1223;
    
    //      outside wall
    
    //  北墙
    SCNBox *wall1 = [SCNBox boxWithWidth:width
                                 height:height
                                 length:depth
                          chamferRadius:0];
    SCNNode *wall1Node = [SCNNode nodeWithGeometry:wall1];
    wall1Node.position = SCNVector3Make(0, height/2.0, -length/2.0+depth/2.0);
    [_scene.rootNode addChildNode:wall1Node];
    
    //  东墙
    SCNBox *wall2 = [SCNBox boxWithWidth:depth
                                  height:height
                                  length:length
                           chamferRadius:0];
    SCNNode *wall2Nodel = [SCNNode nodeWithGeometry:wall2];
    wall2Nodel.position = SCNVector3Make(width/2.0-depth/2.0, height/2.0f, 0);
    [_scene.rootNode addChildNode:wall2Nodel];
    
    //  主卧阳台 南墙
    SCNBox *wall3 = [SCNBox boxWithWidth:368
                                    height:height
                                    length:depth
                             chamferRadius:0];
    SCNNode *wall3Node = [SCNNode nodeWithGeometry:wall3];
    wall3Node.position = SCNVector3Make((width-wall3.width)/2.0, height/2.0, length/2.0-depth/2.0);
    [_scene.rootNode addChildNode:wall3Node];
    
    //  主卧西墙
    SCNBox *wall4 = [SCNBox boxWithWidth:depth
                                  height:height
                                  length:486
                           chamferRadius:0];
    SCNNode *wall4Node = [SCNNode nodeWithGeometry:wall4];
    wall4Node.position = SCNVector3Make(wall1.width/2.0-wall3.width+depth/2.0, height/2.0, wall2.length/2.0-wall4.length/2.0);
    [_scene.rootNode addChildNode:wall4Node];
    
    //  卫生间南墙
    SCNBox *wall5 = [SCNBox boxWithWidth:width-wall3.width
                                  height:height
                                  length:depth
                           chamferRadius:0];
    SCNNode *wall5Node = [SCNNode nodeWithGeometry:wall5];
    wall5Node.position = SCNVector3Make(-(width-wall5.width)/2.0, height/2.0, length/2.0-wall4.length+depth/2.0);
    [_scene.rootNode addChildNode:wall5Node];
    
    //  厕所西墙
    SCNBox *wall6 = [SCNBox boxWithWidth:depth
                                  height:height
                                  length:276
                           chamferRadius:0];
    SCNNode *wall6Node = [SCNNode nodeWithGeometry:wall6];
    wall6Node.position = SCNVector3Make(-width/2.0+60, height/2.0, length/2.0-wall4.length-wall6.length/2.0);
    [_scene.rootNode addChildNode:wall6Node];
    
    //  门厅南墙
    SCNBox *wall7 = [SCNBox boxWithWidth:140 height:height length:depth chamferRadius:0];
    SCNNode *wall7Node = [SCNNode nodeWithGeometry:wall7];
    wall7Node.position = SCNVector3Make(-width/2.0+60, height/2.0, length/2.0-wall4.length-wall6.length+depth/2.0);
    [_scene.rootNode addChildNode:wall7Node];
    
    //  书房西墙
    SCNBox *wall8 = [SCNBox boxWithWidth:depth height:height length:330 chamferRadius:0];
    SCNNode *wall8Node = [SCNNode nodeWithGeometry:wall8];
    wall8Node.position = SCNVector3Make(-width/2.0, height/2.0, -(length-wall8.length)/2.0);
    [_scene.rootNode addChildNode:wall8Node];
    
    
    //      inside wall
    
    
}


- (void)_prepareOtherNode {
    SCNSphere *sun = [SCNSphere sphereWithRadius:2];
    SCNNode *sunNode = [SCNNode nodeWithGeometry:sun];
    sunNode.position = SCNVector3Make(0, 100, 0);
    sunNode.geometry.firstMaterial.emission.contents = [UIColor redColor];
    [_scene.rootNode addChildNode:sunNode];
    
    SCNLight *sunLight = [SCNLight light];
    sunLight.type = SCNLightTypeOmni;
    sunLight.color = [UIColor whiteColor];
    sunNode.light = sunLight;
    
    SCNSphere *earth = [SCNSphere sphereWithRadius:0.5];
    SCNNode *earthNode = [SCNNode nodeWithGeometry:earth];
    earthNode.position = SCNVector3Make(-7, 0, 0);
    earthNode.geometry.firstMaterial.emission.contents = [UIColor blueColor];
    [sunNode addChildNode:earthNode];
    [sunNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:0 z:2 duration:36]]];
    
    SCNSphere *moon = [SCNSphere sphereWithRadius:0.1];
    SCNNode *moonNode = [SCNNode nodeWithGeometry:moon];
    moonNode.position = SCNVector3Make(1, 0, 0);
    [earthNode addChildNode:moonNode];
    [earthNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:0 z:2 duration:1]]];
    
}

- (void)_prepareCubeNode {
    for (int i = 0; i < 27; i ++) {
        SCNBox *box = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];
        SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
        boxNode.position = SCNVector3Make(i%3-1,
                                          i/3-i/9*3-1,
                                          -i/9+1);
        
        [_scene.rootNode addChildNode:boxNode];
        NSLog(@"position = %f %f %f" ,boxNode.position.x, boxNode.position.y, boxNode.position.z);
    }
}

#pragma mark - Touch - Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchBeganPoint = [touches.anyObject locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.view];
    
    float diffX = point.x - _touchBeganPoint.x;
    float diffY = point.y - _touchBeganPoint.y;
    
    /*
     BOOL horizontal = diffX > diffY;
    NSArray *hitResults = [_gameView hitTest:point options:nil];
    
    if (!hitResults.count) {
        return;
    }
    
    SCNHitTestResult *result = hitResults.firstObject;
    if (horizontal) {
        float w_value = 0.05;
        if (point.x - _touchBeganPoint.x < 0) {
            w_value *= -1;
        }
        result.node.rotation = SCNVector4Make(0, 1, 0, result.node.rotation.w+w_value);
    } else {
        float w_value = 0.05;
        if (point.y - _touchBeganPoint.y < 0) {
            w_value *= -1;
        }
        result.node.rotation = SCNVector4Make(1, 0, 0, result.node.rotation.w+w_value);
    }
    */
    
    _cameraNode.position = SCNVector3Make(diffX, _cameraNode.position.y, diffY);
}

@end
