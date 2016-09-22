//
//  CSTabBarController.m
//  CustomShell
//
//  Created by guoyi on 16/6/17.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSTabBarController.h"

#import "CSHomeViewController.h"
#import "CSGameViewController.h"
#import "CSMineViewController.h"

@interface CSTabBarController ()

@end

@implementation CSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CSHomeViewController *homeVC = [[CSHomeViewController alloc] init];
    homeVC.title = @"首页";
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    CSGameViewController *gameVC = [[CSGameViewController alloc] init];
    gameVC.title = @"游戏";
    UINavigationController *gameNavi = [[UINavigationController alloc] initWithRootViewController:gameVC];
    
    CSMineViewController *mineVC = [[CSMineViewController alloc] init];
    mineVC.title = @"我的";
    UINavigationController *mineNavi = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[homeNavi, gameNavi, mineNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark - Public Methods

+ (instancetype)tabBarController {
    CSTabBarController *tabBarController = [[CSTabBarController alloc] init];
    return tabBarController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
