//
//  CSHomeModel.h
//  CustomShell
//
//  Created by 郭毅 on 16/9/8.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSHomeModel : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSArray *pathList;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger stlID;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
