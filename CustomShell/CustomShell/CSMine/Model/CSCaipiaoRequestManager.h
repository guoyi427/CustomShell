//
//  CSCaipiaoRequestManager.h
//  CustomShell
//
//  Created by kokozu on 2017/1/3.
//  Copyright © 2017年 帅毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSCaipiaoRequestManager : NSObject

+ (instancetype)shareInstance;

/**
 按时间 请求当月彩票结果列表

 @param code 彩票代码  例如 bj11x5
 @param date 当月时间  例如 2016-01-02  则返回结果从选取日期到 2016-02-01
 @param successCallback 成功回调
 @param faileCallback 失败回调
 */
- (void)getCaipiaoListWithCode:(NSString *)code
                          Date:(NSString *)date
               SuccessCallback:(void (^)(NSArray *response))successCallback
                 faileCallback:(void (^)(NSError *error))faileCallback;

@end
