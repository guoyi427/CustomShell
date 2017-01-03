//
//  CSCaipiaoRequestManager.m
//  CustomShell
//
//  Created by kokozu on 2017/1/3.
//  Copyright © 2017年 帅毅. All rights reserved.
//

#import "CSCaipiaoRequestManager.h"

@implementation CSCaipiaoRequestManager

+ (instancetype)shareInstance {
    static CSCaipiaoRequestManager *m_request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_request = [[self alloc] init];
    });
    return m_request;
}

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
                 faileCallback:(void (^)(NSError *error))faileCallback {
    //http://t.apiplus.cn/daily.do?code=bj11x5&date=2017-01-02&format=json
    NSString *urlString = [NSString stringWithFormat:@"http://t.apiplus.cn/daily.do?code=%@&date=%@&format=json", code, date];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataList = responseDic[@"data"];
        if (dataList && successCallback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(dataList);
            });
        }
        if (!dataList && faileCallback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                faileCallback(error);
            });
        }
    }];
    [dataTask resume];
    NSLog(@"request succes");
}

@end
