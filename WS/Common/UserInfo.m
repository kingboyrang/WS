//
//  UserInfo.m
//  WS
//
//  Created by gwzd on 14-4-18.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "UserInfo.h"



@implementation UserInfo

@synthesize userId;
@synthesize userName;
@synthesize passWord;
@synthesize companyName;
@synthesize phoneStr;
@synthesize emailStr;
@synthesize project_current_Id;
//@synthesize projectDictionary;
@synthesize project_current_name;


+(UserInfo *)shareInstance{
    static UserInfo *userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[self alloc]init];
//        userInfo.projectDictionary = [[NSMutableDictionary alloc]init];
    });
    return userInfo;
}
@end
