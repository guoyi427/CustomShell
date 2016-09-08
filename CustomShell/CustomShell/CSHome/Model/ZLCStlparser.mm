//
//  ZLCStlparser.m
//  ModelShow_Nic
//
//  Created by shining3d on 16/5/9.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import "ZLCStlparser.h"
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>



using namespace std;
#define MAX_LINE 1024


struct pointInfo
{
    float *squareVertexData;
    int   faceNum;
};


@implementation ZLCStlparser




+ (NSValue *)ParserStlFileWithfilaPath:(NSString *)path
{
    

    
    
    NSValue *value;//用于接受结构体保存的数据信息
    
    
    
//    struct ModelData{
//        float *squareVertexData;
//        int facetNum;
//        int size;
//    };
//    
//    NSValue *value1 = [NewParser getParserDataWithFile:path];
//    
//    //取到解析方法返回的NSValue（携带结构体参数）
//    
//    //定义结构体接受NSValue内的结构体参数
//    struct ModelData pro1 ;
//    [value1 getValue:&pro1];
//    
//    
//    //给结构体赋值
//    pointInfo pro = {pro1.squareVertexData,pro1.facetNum};
//    //结构体转NSValue
//    value = [NSValue valueWithBytes:&pro objCType:@encode(pointInfo)];
    
    
    NSString* mTxt=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    std::ifstream inSTL;
    std::string fp  = [path UTF8String];
    inSTL.open(fp);
    std::string line;
    getline(inSTL, line);

    
    
    if (mTxt == nil) {
        
        NSLog(@"binary");
        
       value = [self parserBinary:path];
        
        
        
        
        
        
        
        
    }
    else
    {
        NSLog(@"ascii");
      value = [self parserAscii:path];
        
    }
    
    
    
    
    pointInfo pro2 ;
    [value getValue:&pro2];
    
//    NSDictionary *dic = @{@"sq":@(*pro2.squareVertexData) ,@"num":@(pro2.faceNum)};
//    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:path];

    
  
    
    
    
    
    
    
    
    
    
    
    

    return value;
    
}


#pragma mark ---解析Ascii
+ (NSValue *)parserAscii:(NSString *)fileName
{
    float *squareVertexData;
    int faceNum;

    
    
    
    const char* destDir = [fileName UTF8String];//将NSString转为char *字符串
    
    
    ifstream inSTL;
    string fp  = destDir;
    destDir = nil;
    inSTL.open(fp);
    vector<float>vec;//定义一个vector容器，用于存储float数组
    
    
    cout<<fp<<endl;
    if(!inSTL.good())
    {
        printf("ERROR OPENING OBJ FILE");
        //        exit(1);
    }
    
    // Read stl file
    int rows = 0;//记录当前读取到得行数
    
    float nor1 = 0.0,nor2 = 0.0,nor3 = 0.0;
    
    while(!inSTL.eof())
    {
        string line;
        getline(inSTL, line);
        
        
        //            squareVertexData = (float *)realloc(squareVertexData, sizeof(float)*24);
        //判断是否为所需行数
        /*------------------------------narmal--------------------------------------------*/
        if (rows%7 == 1) {
            
            
            
            
            
            
            std::string str = line;//获取此行字符串
            //下述从开始到结束，为处理当前行数据以空格分隔成新的多个字符串存放在vector里
            //----------开始---------
            auto it2 = std::find_if( str.begin() , str.end() , [](char ch){
                return !std::isspace<char>(ch , std::locale::classic() ) ;
            });
            str.erase(str.begin(), it2);
            
            std::vector<std::string> vector;
            
            std::string::size_type pos1, pos2;
            string pattern = " ";
            pos2 = str.find(pattern);
            pos1 = 0;
            while(std::string::npos != pos2)
            {
                vector.push_back(str.substr(pos1, pos2-pos1));
                
                pos1 = pos2 + pattern.size();
                pos2 = str.find(pattern, pos1);
            }
            if(pos1 != str.length()) {
                vector.push_back(str.substr(pos1));
            }
            
            //----------结束---------
            
            
            
            
            int cccc=0;
            for( auto i : vector){
                
                //判断当前字符串是否为空格，如为空格，进行下一次循环
                if (i == "\0") {
                    continue;
                }
                
                
                //normal 第一个数
                if (cccc == 2) {
                    
                    nor1 = atof(i.c_str());//normal1
                    
                }
                else if (cccc == 3)
                {
                    
                    nor2 = atof(i.c_str());//normal2
                    
                    
                    
                    
                    
                }
                else if (cccc == 4)
                {
                    
                    nor3 = atof(i.c_str());//normal3
                    
                    
                    
                    
                }
                
                cccc++;
            }
        }
        /*------------------------------vertex1--------------------------------------------*/
        else if(rows%7 == 3)
        {
            std::string str = line;
            
            auto it2 = std::find_if( str.begin() , str.end() , [](char ch){
                return !std::isspace<char>(ch , std::locale::classic() ) ;
            });
            str.erase(str.begin(), it2);
            
            std::vector<std::string> vector;
            
            std::string::size_type pos1, pos2;
            string pattern = " ";
            pos2 = str.find(pattern);
            
            pos1 = 0;
            while(std::string::npos != pos2)
            {
                vector.push_back(str.substr(pos1, pos2-pos1));
                
                pos1 = pos2 + pattern.size();
                pos2 = str.find(pattern, pos1);
            }
            if(pos1 != str.length()) {
                vector.push_back(str.substr(pos1));
            }
            
            
            int cccc=0;
            for( auto i : vector){
                
                
                
                
                //判断当前字符串是否为空格，如为空格，进行下一次循环
                if (i == "\0") {
                    continue;
                }
                
                
                if (cccc == 1) {
                    
                    vec.push_back(atof(i.c_str()));//将第一个点得x添加到数组
                    
                }
                else if(cccc == 2)
                {
                    vec.push_back(atof(i.c_str()));//将第一个点得y添加到数组
                }
                else if(cccc == 3)
                {
                    
                    
                    vec.push_back(atof(i.c_str()));//将第一个点得z添加到数组
                    vec.push_back(nor1);//normal x
                    vec.push_back(nor2);//y
                    vec.push_back(nor3);//z
                    vec.push_back(1.0);
                    vec.push_back(1.0);
                    
                    
                }
                
                
                cccc++;
            }
        }
        /*------------------------------vertex2--------------------------------------------*/
        else if(rows%7 == 4)
        {
            std::string str = line;
            
            auto it2 = std::find_if( str.begin() , str.end() , [](char ch){
                return !std::isspace<char>(ch , std::locale::classic() ) ;
            });
            str.erase(str.begin(), it2);
            
            std::vector<std::string> vector;
            
            std::string::size_type pos1, pos2;
            string pattern = " ";
            pos2 = str.find(pattern);
            pos1 = 0;
            while(std::string::npos != pos2)
            {
                vector.push_back(str.substr(pos1, pos2-pos1));
                
                pos1 = pos2 + pattern.size();
                pos2 = str.find(pattern, pos1);
            }
            if(pos1 != str.length()) {
                vector.push_back(str.substr(pos1));
            }
            
            
            int cccc=0;
            for( auto i : vector){
                
                //判断当前字符串是否为空格，如为空格，进行下一次循环
                if (i == "\0") {
                    continue;
                }
                
                
                
                if (cccc == 1) {
                    vec.push_back(atof(i.c_str()));//将当前片面第2点x坐标存入vec
                    
                }
                else if(cccc == 2)
                {
                    vec.push_back(atof(i.c_str()));//将当前片面第2点y坐标存入vec
                }
                else if(cccc == 3)
                {
                    
                    
                    
                    vec.push_back(atof(i.c_str()));//将当前片面第2点z坐标存入vec
                    vec.push_back(nor1);//nor x
                    vec.push_back(nor2);//y
                    vec.push_back(nor3);//z
                    vec.push_back(1.0);
                    vec.push_back(1.0);
                    
                }
                
                
                
                cccc++;
            }
        }
        /*------------------------------vertex3--------------------------------------------*/
        else if(rows%7 == 5)
        {
            std::string str = line;
            
            auto it2 = std::find_if( str.begin() , str.end() , [](char ch){
                return !std::isspace<char>(ch , std::locale::classic() ) ;
            });
            str.erase(str.begin(), it2);
            
            std::vector<std::string> vector;
            
            std::string::size_type pos1, pos2;
            string pattern = " ";
            pos2 = str.find(pattern);
            pos1 = 0;
            while(std::string::npos != pos2)
            {
                vector.push_back(str.substr(pos1, pos2-pos1));
                
                pos1 = pos2 + pattern.size();
                pos2 = str.find(pattern, pos1);
            }
            if(pos1 != str.length()) {
                vector.push_back(str.substr(pos1));
            }
            
            
            int cccc=0;
            for( auto i : vector){
                
                
                //判断当前字符串是否为空格，如为空格，进行下一次循环
                if (i == "\0") {
                    continue;
                }
                
                
                
                if (cccc == 1) {
                    
                    vec.push_back(atof(i.c_str()));//将当前片面第三点x坐标存入vec
                    
                }
                else if(cccc == 2)
                {
                    vec.push_back(atof(i.c_str()));//将当前片面第三点y坐标存入vec
                }
                else if(cccc == 3)
                {
                    
                    vec.push_back(atof(i.c_str()));//将当前片面第三点x坐标存入vec
                    vec.push_back(nor1);//加入normalx
                    vec.push_back(nor2);//y
                    vec.push_back(nor3);//z
                    vec.push_back(1.0);
                    vec.push_back(1.0);
                    
                    
                }
                
                
                cccc++;
            }
        }
        
        
        
        
        
        
        rows++;
        
    }
    
    
    inSTL.close();
    
    
    
    faceNum = (rows-2)/7;
    
    
    
    
    
    //    cout<<vec.size()<<endl;//求vec数据个数
    squareVertexData = (float *)malloc(vec.size()*sizeof(float));
    for (int i = 0; i < vec.size(); i++) {
        
        squareVertexData[i] = vec[i];
        
    }
    vec.clear();
    
    
    
    
    
    
    
    
    //给结构体赋值
    pointInfo pro = {squareVertexData,faceNum};
    //结构体转NSValue
    NSValue *value = [NSValue valueWithBytes:&pro objCType:@encode(pointInfo)];
    
    
    return value;
    
    
    
    
}

#pragma mark ---解析binary
+ (NSValue *)parserBinary:(NSString *)fileName
{
    
    
    float *squareVertexData;
    int faceNum;
    
    //binnary
    NSLog(@"binnary");
    NSData *reader = [NSData dataWithContentsOfFile:fileName];//将文件转为NSData二进制格式
    
    
    
    
    char dataBuf[100];
    int offset = 0;
    [reader getBytes:&dataBuf range:NSMakeRange(offset, 80)];//读取stl文件的0-80字节，此段为stl文件的文件名
    faceNum = 0;
    [reader getBytes:&faceNum range:NSMakeRange(80,4)];//读取stl文件的80-84字节，此段为stl的三角面片个数
    NSLog(@"face个数:%d",faceNum);
    
    
    squareVertexData = (float *)malloc(faceNum*24*sizeof(float));
    
    
    int currRange = 80;//设定当前字节下标，默认从84开始读起起，即跳过文件名及face总数直接读取有效数据
    
    
    for (int x = 0; x < faceNum ; x++) {
        
        
        
        
        int count = 0;
        
        float curr = 0.0;//临时变量
        
        
        
        [reader getBytes:&curr range:NSMakeRange(currRange+16, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        [reader getBytes:&curr range:NSMakeRange(currRange+20, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        [reader getBytes:&curr range:NSMakeRange(currRange+24, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        
        
        [reader getBytes:&curr range:NSMakeRange(currRange+4, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        [reader getBytes:&curr range:NSMakeRange(currRange+8, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        [reader getBytes:&curr range:NSMakeRange(currRange+12, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        squareVertexData[x*24+count] = 1.0;
        count++;
        squareVertexData[x*24+count] = 1.0;
        count++;
        
        
        
        
        
        
        
        
        
        [reader getBytes:&curr range:NSMakeRange(currRange+28, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        [reader getBytes:&curr range:NSMakeRange(currRange+32, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        [reader getBytes:&curr range:NSMakeRange(currRange+36, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        
        
        
        
        
        [reader getBytes:&curr range:NSMakeRange(currRange+4, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        [reader getBytes:&curr range:NSMakeRange(currRange+8, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        
        [reader getBytes:&curr range:NSMakeRange(currRange+12, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        
        squareVertexData[x*24+count] = 1.0;
        count++;
        squareVertexData[x*24+count] = 1.0;
        count++;
        
        
        
        [reader getBytes:&curr range:NSMakeRange(currRange+40, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        
        [reader getBytes:&curr range:NSMakeRange(currRange+44, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        [reader getBytes:&curr range:NSMakeRange(currRange+48, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        
        [reader getBytes:&curr range:NSMakeRange(currRange+4, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        
        
        [reader getBytes:&curr range:NSMakeRange(currRange+8, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        [reader getBytes:&curr range:NSMakeRange(currRange+12, 4)];
        squareVertexData[x*24+count] = curr;
        count++;
        
        
        squareVertexData[x*24+count] = 1.0;
        count++;
        squareVertexData[x*24+count] = 1.0;
        count++;
        
        
        currRange = currRange  + 50;//每个三角面信息的最后两个字节为描述字节，无用。+掉
        
        
        
    }
    
    reader = nil;
    
    

    //给结构体赋值
    pointInfo pro = {squareVertexData,faceNum};
    //结构体转NSValue
    NSValue *value = [NSValue valueWithBytes:&pro objCType:@encode(pointInfo)];
    
    
    
    
        
    return value;
    
    
}

#pragma mark - Scale

+ (void)scaleVertices:(float *)_stl_vertices count:(int)_faceCount {
    
    //定义出6个变量用于储存最小和最大的xyz
    float xMax = _stl_vertices[0];
    float yMax = _stl_vertices[1];
    float zMax = _stl_vertices[2];
    
    float xMin = _stl_vertices[0];
    float yMin = _stl_vertices[1];
    float zMin = _stl_vertices[2];
    
    
    
    NSLog(@"点个数:%d",_faceCount*24);
    //循环获取最小最大xyz
    for (int i=0; i<_faceCount*24; i++) {
        if ((i+1)%8 == 1) {
            
            if (_stl_vertices[i] > xMax) {
                xMax = _stl_vertices[i];
            }
            
            if (_stl_vertices[i] < xMin)
            {
                xMin = _stl_vertices[i];
            }
            
            
            
        }
        else if ((i+1)%8 == 2) {
            
            if (_stl_vertices[i] > yMax) {
                yMax = _stl_vertices[i];
            }
            
            if (_stl_vertices[i] < yMin)
            {
                yMin = _stl_vertices[i];
            }
            
            
        }
        else if ((i+1)%8 == 3) {
            
            
            if (_stl_vertices[i] > zMax) {
                zMax = _stl_vertices[i];
            }
            
            if (_stl_vertices[i] < zMin)
            {
                zMin = _stl_vertices[i];
            }
        }
        
    }
    
    
    NSLog(@"xyz最小：%f,%f,%f",xMin,yMin,zMin);
    NSLog(@"xyz最大：%f,%f,%f",xMax,yMax,zMax);
    
    NSLog(@"中心点坐标为:%f,%f,%f",(xMax-xMin)/2+xMin,(yMax-yMin)/2+yMin,(zMax-zMin)/2+zMin);
    
    
    
    //求出最长的长径
    float diameter = -200.0;
    
    if ((xMax-xMin)>=(yMax-yMin) && (xMax-xMin)>=(zMax - zMin)) {
        diameter = xMax-xMin;
    }
    if ((yMax-yMin)>=(xMax-xMin) && (yMax-yMin)>=(zMax - zMin)) {
        diameter = yMax-yMin;
    }
    if ((zMax-zMin)>=(yMax-yMin) && (xMax-xMin)<=(zMax - zMin)) {
        diameter = zMax-zMin;
    }
    
    NSLog(@"最长的长径：%f",diameter);
    
    //算出一个合适的比例展示模型 最大直径 控制到2.0
    float bili = 2.0/diameter;
    
    
    float midX,midY,midZ;
    midX =(xMax-xMin)/2+xMin;
    midY =(yMax-yMin)/2+yMin;
    midZ =(zMax-zMin)/2+zMin;
    
    
    
    
    for (int i=0; i<_faceCount*24; i++) {
        float tem = _stl_vertices[i];
        if ((i+1)%8 == 1) {
            _stl_vertices[i] = (tem - midX)*bili;
        }
        else if((i+1)%8 == 2)
        {
            _stl_vertices[i] = (tem - midY)*bili;
        }
        else if ((i+1)%8 == 3)
        {
            _stl_vertices[i] = (tem - midZ)*bili;
        }
        else
        {
            _stl_vertices[i] = tem;
        }
    }
}

@end
