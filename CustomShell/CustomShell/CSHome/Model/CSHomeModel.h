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
/// 网络地址和本地路径映射表 key 网络路径   value 本地路径
@property (nonatomic, strong) NSMutableDictionary *filePathDic;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
