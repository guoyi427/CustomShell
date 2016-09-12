//
//  CSShellViewController.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/8.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSShellViewController.h"

#import "CSGLView.h"
#import "CSHomeModel.h"

@interface CSShellViewController ()
{
    CSGLView *_glView;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIPageControl *_pageControl;
    
    //  Data
    NSInteger _currentIndex;
}
@end

@implementation CSShellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _glView = [[CSGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_glView];
    
    
    if (_model.pathList.count > 1) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(10, CGRectGetHeight(self.view.frame)/2 - 40, 30, 60);
        _leftButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [_leftButton setTitle:@"←" forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.hidden = YES;
        [self.view addSubview:_leftButton];

        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, CGRectGetHeight(self.view.frame)/2 - 40, 30, 60);
        _rightButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [_rightButton setTitle:@"→" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_rightButton];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_model.pathList) {
        [_glView renderStlWithURL:_model.pathList.firstObject];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private - Methods

- (void)updateShellVC {
    if (_currentIndex < _model.pathList.count) {
        [_glView clearup];
        NSString *currentPath = _model.pathList[_currentIndex];
        [_glView renderStlWithURL:currentPath];
    }
}


#pragma mark - Button - Action

- (void)leftButtonAction {
    if (_currentIndex > 0) {
        _currentIndex --;
    }
    if (_currentIndex == 0) {
        _leftButton.hidden = YES;
    }
    if (_currentIndex < _model.pathList.count - 1) {
        _rightButton.hidden = NO;
    }
}

- (void)rightButtonAction {
    if (_currentIndex < _model.pathList.count - 1) {
        _currentIndex ++;
    }
    if (_currentIndex >= _model.pathList.count - 1) {
        _rightButton.hidden = YES;
    }
    if (_currentIndex > 0) {
        _leftButton.hidden = NO;
    }
}


@end
