//
//  CS3DprintView.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/27.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CS3DprintView.h"

#import <SceneKit/SceneKit.h>

@interface CS3DprintView ()
{
    SCNScene *_scene;
    
}
@end

@implementation CS3DprintView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scene = [SCNScene scene];
        
        SCNNode *cameraNode = [SCNNode node];
        cameraNode.camera = [SCNCamera camera];
        cameraNode.position = SCNVector3Make(0, 100, 100);
        [_scene.rootNode addChildNode:cameraNode];
        
        SCNNode *lightNode = [SCNNode node];
        lightNode.light = [SCNLight light];
        lightNode.light.color = [UIColor whiteColor];
        
    }
    return self;
}

@end
