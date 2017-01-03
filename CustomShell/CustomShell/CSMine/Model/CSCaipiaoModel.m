//
//  CSCaipiaoModel.m
//  CustomShell
//
//  Created by kokozu on 2017/1/3.
//  Copyright © 2017年 帅毅. All rights reserved.
//

#import "CSCaipiaoModel.h"

@implementation CSCaipiaoModel

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    CSCaipiaoModel *model = [[CSCaipiaoModel alloc] init];
    model.expect = dic[@"expect"];
    model.opencode = dic[@"opencode"];
    model.opentime = dic[@"opentime"];
    model.opentimestamp = dic[@"opentimestamp"];
    return model;
}

/**
 计算彩票分布
 
 @param caipiaoList 彩票列表
 */
+ (void)calculateCaipiaoDistribution:(NSArray<CSCaipiaoModel *> *)caipiaoList successCallback:(void (^)(NSArray *))successCallback {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /// 分布列表 将所有统计结果加到此数组中
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:10];
        /// 彩票单数 容器  count = 彩票数字个数
        NSMutableArray *caipiaoUnitlList = [[NSMutableArray alloc] initWithCapacity:[caipiaoList.firstObject.opencode componentsSeparatedByString:@","].count];
        
        
        
        //  彩票期数
        NSUInteger modelCount = caipiaoList.count;
        //  提取号码
        for (int i = 0; i < modelCount; i ++) {
            //  某一期的彩票的所有数字
            NSString *codeString = caipiaoList[i].opencode;
            NSArray *codeList = [codeString componentsSeparatedByString:@","];
            NSUInteger codeCount = codeList.count;
            // 将某一期的彩票数字 放到对应的位置中，不同的位置统计不同的概率
            for (int j = 0; j < codeCount; j ++) {
                
            }
        }
        
    });
}
@end
