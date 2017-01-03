//
//  CSCaipiaoModel.h
//  CustomShell
//
//  Created by kokozu on 2017/1/3.
//  Copyright © 2017年 帅毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCaipiaoModel : NSObject

@property (nonatomic, copy) NSString *expect;
@property (nonatomic, copy) NSString *opencode;
@property (nonatomic, copy) NSString *opentime;
@property (nonatomic, copy) NSString *opentimestamp;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

/**
 计算彩票分布

 @param caipiaoList 彩票列表
 */
+ (void)calculateCaipiaoDistribution:(NSArray<CSCaipiaoModel *> *)caipiaoList
                     successCallback:(void (^)(NSArray *resultList))successCallback;

@end
