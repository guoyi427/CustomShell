//
//  CSMineViewController.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/21.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSMineViewController.h"

//  View
#import "CSPrintView.h"

//  Model
#import "CSCaipiaoRequestManager.h"

//  Controller
#import "CSCaipiaoHistoryViewController.h"

@interface CSMineViewController ()
{
    
}
@end

@implementation CSMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _prepareData];
    [self _prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare

- (void)_prepareData {

}

- (void)_prepareUI {
    UIButton *caipiaoHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    caipiaoHistoryBtn.frame = CGRectMake(10, 10, ScreenWidth/2.0f, ScreenWidth/2.0);
    [caipiaoHistoryBtn setTitle:@"History" forState:UIControlStateNormal];
    [caipiaoHistoryBtn addTarget:self action:@selector(caipiaoHistoryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:caipiaoHistoryBtn];
    
}

#pragma mark - Button - Action

- (void)caipiaoHistoryButtonAction {
    CSCaipiaoHistoryViewController *historyController = [[CSCaipiaoHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyController animated:YES];
}


@end
