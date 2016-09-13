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
#import "CSDownloadManager.h"
#import "NSString+MD5.h"

@interface CSShellViewController ()
{
    CSGLView *_glView;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIPageControl *_pageControl;
    UIActivityIndicatorView *_indicatorView;
    UIView *_progressView;
    
    //  Data
    NSInteger _currentIndex;
    long long _stlDataLength;
}
@end

@implementation CSShellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _glView = [[CSGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_glView];
    
    
    if (_model.pathList) {
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
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _indicatorView.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:_indicatorView];
    
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 0, 2)];
    _progressView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_progressView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(self.view.frame) - 30, CGRectGetWidth(self.view.frame), 10)];
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = _model.pathList.count;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_model.pathList) {
        [self _updateShellVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private - Methods

- (void)_updateShellVC {
    if (_currentIndex < _model.pathList.count) {
        _pageControl.currentPage = _currentIndex;
        [[CSDownloadManager instance] cancelAll];
        [self _updateProgressViewFrameWithProgress:0];
        [_glView clearup];
        NSString *currentPath = _model.pathList[_currentIndex];
        //  判断本地是否存在 如果不存在就下载
        NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.stl", [currentPath mc_md5]]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [_glView renderStlWithPath:filePath];
        } else {
            [_indicatorView startAnimating];
            __weak CSShellViewController *weakSelf = self;
            [[CSDownloadManager instance] downloadWithApi:currentPath
                                          successCallBack:^(NSURLResponse *response, long long length) {
                                              _stlDataLength = length;
                                              [weakSelf _updateProgressViewFrameWithProgress:0];
                                          }
                                            faildCallBack:^(NSError *error) {
                                                NSLog(@"error");
                                                [_indicatorView stopAnimating];
                                            }
                                         receivedCallback:^(NSData *receiveData) {
                                             float progressValue = (receiveData.length/1024.0f) / (_stlDataLength/1024.0f);
                                             [weakSelf _updateProgressViewFrameWithProgress:progressValue];
                                         }
                                         finishedCallBack:^(NSData *data) {
                                             NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
                                             filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.stl", [currentPath mc_md5]]];
                                             [data writeToFile:filePath atomically:YES];
                                             [_glView renderStlWithPath:filePath];
                                             [_model.filePathDic setValue:filePath forKey:currentPath];
                                             [_indicatorView stopAnimating];
                                             [weakSelf _updateProgressViewFrameWithProgress:0];
                                             data = nil;
                                         }];
        }
    }
}

- (void)_updateProgressViewFrameWithProgress:(float)progress {
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);

    CGRect progressViewFrame = _progressView.frame;
    progressViewFrame.size.width = screenWidth * progress;
    _progressView.frame = progressViewFrame;
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
    [self _updateShellVC];
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
    [self _updateShellVC];
}


@end
