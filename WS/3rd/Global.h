//
//  Global.h
//  weishiDemo
//
//  Created by apple  on 14-3-5.
//  Copyright (c) 2014年 apple . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaoZuoClass.h"
#import "FujianClass.h"
#import "Header.h"
@interface Global : NSObject

+(NSString *)tishiMessage:(NSString *)resultMessage;
+(NSDictionary *)GetjsonStr:(NSMutableString *)str;
+(NSMutableArray *)resultArray:(NSDictionary *)jsonDic :(int) i  :(NSString *)type : (CaoZuoClass *)czClass where:(NSString *)whereStr;
+(NSString *)readState:(NSString *)str;  //阅读状态
+(NSString *)dealState:(NSString *)str;  //处理状态
+(NSString *)isFault:(NSString *)str;    //是否故障

+(NSString *)xiaoxiType:(NSString *)type;
//最大字段
+(int)TableName:(NSString *)tabName where:(NSString *)seleStr isFault: (BOOL)isfault zuidaZhuanfa:(BOOL)zhuanfa;
//设置数据库附件文件路径
+(NSString*)FilePaths:(NSString *)imageName;

+ (NSString*)getPreferredLanguage;
@end
