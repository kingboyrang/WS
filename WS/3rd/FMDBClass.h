//
//  FMDBClass.h
//  weishiDemo
//
//  Created by apple  on 14-3-11.
//  Copyright (c) 2014年 apple . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Header.h"
#import "PersonInfoClass.h"
#import "FujianClass.h"
@interface FMDBClass : NSObject
{
    FMDatabase *db;
}
@property (nonatomic, strong)FMDatabase *db;
+(FMDBClass *)shareInstance;
- (void)resetInit;
#pragma mark 创建数据表
-(void)createTable;
#pragma mark 添加信息
-(void)insertDate:(NSString *)tableName date:(NSArray *)array : (NSString *)userid;
#pragma mark 查询是否已经收藏
-(NSMutableArray *)seleDate:(NSString *)tableName  wherestr:(NSString *)str;
#pragma mark 更新
-(void)UpData:(NSString *)tableName setStr:(NSString *)setStr  whereStr:(NSString *)whereStr;
@end
