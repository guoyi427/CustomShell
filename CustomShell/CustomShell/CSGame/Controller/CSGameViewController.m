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
    //[self _prepareOtherNode];
    [self _prepareCubeNode];
}

#pragma mark - Prepare

- (void)_prepareScene {
    _scene = [SCNScene scene];
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 10);
    [_scene.rootNode addChildNode:cameraNode];
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(10, 10, 10);
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
    //view.allowsCameraControl = YES;
    [self.view addSubview:_gameView];
}

- (void)_prepareOtherNode {
    SCNSphere *sun = [SCNSphere sphereWithRadius:2];
    SCNNode *sunNode = [SCNNode nodeWithGeometry:sun];
    sunNode.position = SCNVector3Make(0, 0, -20);
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

@end
