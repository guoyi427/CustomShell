//
//  CSMineViewController.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/21.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSMineViewController.h"

#import "CSPrintView.h"

@interface CSMineViewController ()
{
    @private
    CSPrintView *_printView;
}
@end

@implementation CSMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _printView = [[CSPrintView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_printView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch - Delegate

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.view];
    
    [_printView addPoint:point];
}

@end
