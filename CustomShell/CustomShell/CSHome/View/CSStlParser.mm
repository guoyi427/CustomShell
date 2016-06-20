//
//  CSStlParser.m
//  CustomShell
//
//  Created by guoyi on 16/6/20.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSStlParser.h"

struct pointInfo
{
    float *squareVertexData;
    int   faceNum;
};

@implementation CSStlParser

+ (NSValue *)stlWithFilePath:(NSString *)filePath {
    
    /// stl数据源二进制对象
    NSData *stlData = [NSData dataWithContentsOfFile:filePath];
    
    
    /// 名称缓存
    char title_stl[100];
    /// 三角个数
    int faceCount = 0;
    
    //  0到80 保存的为 stl的文件名称
    [stlData getBytes:title_stl length:80];
    //  80后的4字节为 stl的三角个数
    [stlData getBytes:&faceCount range:NSMakeRange(80, 4)];
    
    NSLog(@"title = %s faceCount = %d" ,title_stl ,faceCount);
    
    /// 缓存 顶点数据
    float vertexData[faceCount*24];
    /// 缓存 顶点数组的下标 用于取值  从 84开始
    int currentIndex = 84;
    
    /// 循环 faceCount次 遍历所有顶点坐标
    for (int i = 0; i < faceCount; i ++) {
        
        /// 本次的数据下标
        int count = 0;
        
        float tempValue = 0.0f;
        
        /// 第一个点
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 12, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 12 + 4, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 12 + 8, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        /// 第二个点
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 4, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 8, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        ///
        vertexData[i*24+count] = 1.0f;
        count++;
        vertexData[i*24+count] = 1.0f;
        count++;
        
        /// 第三个点
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 24, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 24 + 4, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 24 + 8, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        
        /// 第四个点
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 4, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 8, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;

        ///
        vertexData[i*24+count] = 1.0f;
        count++;
        vertexData[i*24+count] = 1.0f;
        count++;
        
        /// 第五个点
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 16, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 16 + 4, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 16 + 8, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        /// 第六个点
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 4, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        [stlData getBytes:&tempValue range:NSMakeRange(currentIndex + 8, 4)];
        vertexData[i*24+count] = tempValue;
        count ++;
        
        ///
        vertexData[i*24+count] = 1.0f;
        count++;
        vertexData[i*24+count] = 1.0f;
        count++;
        
        /// 每个三角形数据中 最后两字节为描述字节 无用
        currentIndex += 50;
        
    }
    
    stlData = nil;

    pointInfo pro = {vertexData, faceCount};
    
    NSValue *value = [NSValue valueWithBytes:&pro objCType:@encode(pointInfo)];
    
    return value;
}

@end
