//
//  CSShellViewController.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/8.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSShellViewController.h"

#import "CSGLView.h"

@interface CSShellViewController ()
{
    CSGLView *_glView;
}
@end

@implementation CSShellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _glView = [[CSGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_glView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_glView renderStlWithName:@"DLAM"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
