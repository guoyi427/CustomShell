//
//  CSTabBarController.m
//  CustomShell
//
//  Created by guoyi on 16/6/17.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSTabBarController.h"

#import "CSHomeViewController.h"

@interface CSTabBarController ()

@end

@implementation CSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
