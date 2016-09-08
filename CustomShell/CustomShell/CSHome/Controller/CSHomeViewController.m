//
//  CSHomeViewController.m
//  CustomShell
//
//  Created by guoyi on 16/6/17.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSHomeViewController.h"

//  Controller
#import "CSShellViewController.h"

@interface CSHomeViewController ()

@end

@implementation CSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame = CGRectMake(100, 100, 100, 40);
    [enterBtn setTitle:@"进入" forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (void)enterButtonAction {
    CSShellViewController *shellVC = [[CSShellViewController alloc] init];
    shellVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shellVC animated:YES];
}

@end
