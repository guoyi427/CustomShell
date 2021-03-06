//
//  CSDownloadManager.h
//  CustomShell
//
//  Created by 郭毅 on 16/9/13.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessCallBack)(NSURLResponse *response, long long length);
typedef void(^FaildCallBack)(NSError *error);
typedef void(^ReceivedCallBack)(NSData *receiveData);
typedef void(^FinishedCallBack)(NSData *data);

static NSString *HostURLString = @"http://192.168.28.137/";//@"http://10.15.151.114/";//@"http://1.119.0.59/";

@interface CSDownloadManager : NSObject

+ (instancetype)instance;

- (void)downloadWithApi:(NSString *)api
        successCallBack:(SuccessCallBack)success
          faildCallBack:(FaildCallBack)faild
       receivedCallback:(ReceivedCallBack)received
       finishedCallBack:(FinishedCallBack)finished;

- (void)cancelAll;

@end
