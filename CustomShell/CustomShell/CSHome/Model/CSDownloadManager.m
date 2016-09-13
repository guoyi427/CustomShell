//
//  CSDownloadManager.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/13.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSDownloadManager.h"

@interface CSDownloadManager ()
{
    NSURLConnection *_connection;
    
    NSMutableData *_receiveData;
    long long _dataLength;
    SuccessCallBack _successCallBack;
    FaildCallBack _faildCallBack;
    ReceivedCallBack _receivedCallBack;
    FinishedCallBack _finishedCallBack;
}

@end

@implementation CSDownloadManager

+ (instancetype)instance {
    CSDownloadManager *manager = [[CSDownloadManager alloc] init];
    return manager;
}

- (void)downloadWithApi:(NSString *)api
        successCallBack:(SuccessCallBack)success
          faildCallBack:(FaildCallBack)faild
       receivedCallback:(ReceivedCallBack)received
       finishedCallBack:(FinishedCallBack)finished {
    
    _successCallBack = success;
    _faildCallBack = faild;
    _receivedCallBack = received;
    _finishedCallBack = finished;
    
    NSString *urlString = [NSString stringWithFormat:@"http://localhost/Download/%@", api];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    if (_connection) {
        [_connection cancel];
    }
    _connection = [NSURLConnection connectionWithRequest:req delegate:self];
    [_connection start];
}

- (void)cancelAll {
    [_connection cancel];
}

#pragma mark - Connection - Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {//该方法在响应connection时调用
    
    NSLog(@"response");
    _receiveData = nil;
    _receiveData = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        
        _dataLength = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
        
    }//获取文件文件的大小
    _successCallBack(response, _dataLength);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {//出错时调用
    NSLog(@"error %@",error);
    _faildCallBack(error);
    _receiveData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {//接受数据，在接受完成之前，该方法重复调用
    [_receiveData appendData:data];
    _receivedCallBack(_receiveData);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {//完成时调用
    NSLog(@"Finish");
    _finishedCallBack(_receiveData);
    _receiveData = nil;
}

@end
