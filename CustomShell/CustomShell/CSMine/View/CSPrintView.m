//
//  CSPrintView.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/21.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSPrintView.h"

@interface CSPrintView ()
{
    @private
    NSMutableArray *_pointCache;
    CAEmitterLayer *_emitterLayer;
}

@end

@implementation CSPrintView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pointCache = [[NSMutableArray alloc] initWithCapacity:200];
        self.backgroundColor = [UIColor blackColor];
        //[self _prepareEmitterLayer];
    }
    return self;
}

- (void)_prepareEmitterLayer {
    _emitterLayer = [[CAEmitterLayer alloc] init];
    _emitterLayer.emitterPosition = CGPointMake(CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame)/2.0f);
    _emitterLayer.emitterSize = CGSizeMake(50, 50);
    _emitterLayer.renderMode = kCAEmitterLayerAdditive;
    //_emitterLayer.emitterShape = kCAEmitterLayerCircle;
    //_emitterLayer.emitterMode = kCAEmitterLayerOutline;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 10;
    cell.lifetime = 0.25;
    cell.color = [UIColor yellowColor].CGColor;
    cell.contents = CFBridgingRelease([UIImage imageNamed:@"white"].CGImage);
    
    //cell.velocity = 0;
    //cell.velocityRange = 3;
    //cell.emissionLongitude = M_PI+M_PI_2;
    //cell.emissionRange = M_PI*2;
    
    cell.scale = 0.5;
    //cell.scaleSpeed = 40;
    
    _emitterLayer.emitterCells = @[cell];
    [self.layer addSublayer:_emitterLayer];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!_pointCache.count) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSUInteger count = _pointCache.count;
    for (int i = 0; i < count; i ++) {
        CGPoint point = [_pointCache[i] CGPointValue];
        if (i == 1) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
        
        if (i > count - 10) {
            path.lineWidth = 3 + count - i;
        } else {
            path.lineWidth = 3;
        }
    }
    [[UIColor yellowColor] setStroke];
    [path stroke];
    
}

#pragma mark - Public - Methods

- (void)addPoint:(CGPoint)point {
    [_pointCache addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
    _emitterLayer.emitterPosition = point;
}


@end
