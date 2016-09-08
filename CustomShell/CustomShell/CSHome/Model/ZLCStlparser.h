//
//  ZLCStlparser.h
//  ModelShow_Nic
//
//  Created by shining3d on 16/5/9.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLCStlparser : NSObject




//解析obj文件，根据文件路径
+ (NSValue *)ParserStlFileWithfilaPath:(NSString *)path;

+ (void)scaleVertices:(float *)_stl_vertices count:(int)_faceCount;

@end
