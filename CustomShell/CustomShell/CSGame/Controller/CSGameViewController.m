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
}
@end
@implementation CSGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _prepareScene];
    [self _prepareFloor];
    [self _prepareWall];
    [self _prepareOtherNode];
//    [self _prepareCubeNode];
}

#pragma mark - Prepare

- (void)_prepareScene {
    _scene = [SCNScene scene];
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 1000, 1000);
    cameraNode.camera.zFar = 4000;
    [_scene.rootNode addChildNode:cameraNode];
    
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
    _gameView.allowsCameraControl = YES;
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
    
    SCNBox *wall = [SCNBox boxWithWidth:808
                                 height:height
                                 length:depth
                          chamferRadius:0];
    SCNNode *wallNode = [SCNNode nodeWithGeometry:wall];
    wallNode.position = SCNVector3Make(0, height/2.0, -1223/2.0+depth/2.0);
    [_scene.rootNode addChildNode:wallNode];
    
    SCNBox *wall2 = [SCNBox boxWithWidth:depth
                                  height:height
                                  length:1223
                           chamferRadius:0];
    SCNNode *wall2Nodel = [SCNNode nodeWithGeometry:wall2];
    wall2Nodel.position = SCNVector3Make(404-depth/2.0, height/2.0f, 0);
    [_scene.rootNode addChildNode:wall2Nodel];
    
    SCNBox *wall3 = [SCNBox boxWithWidth:368
                                    height:height
                                    length:depth
                             chamferRadius:0];
    SCNNode *wall3Node = [SCNNode nodeWithGeometry:wall3];
    wall3Node.position = SCNVector3Make(220, height/2.0, 1223/2.0-depth/2.0);
    [_scene.rootNode addChildNode:wall3Node];
    
    
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
/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchBeganPoint = [touches.anyObject locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.view];
    
    float diffX = fabs(point.x - _touchBeganPoint.x);
    float diffY = fabs(point.y - _touchBeganPoint.y);
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
    
}
*/
@end
