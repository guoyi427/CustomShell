//
//  CSHomeModel.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/8.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSHomeModel.h"

@implementation CSHomeModel

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    CSHomeModel *model = [[CSHomeModel alloc] init];
    model.name = dic[@"name"];
    model.stlID = [dic[@"id"] integerValue];
    model.imageURL = dic[@"imageURL"];
    model.pathList = dic[@"stlURL"];
    model.filePathDic = [[NSMutableDictionary alloc] init];
    return model;
}

@end
