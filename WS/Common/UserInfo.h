//
//  UserInfo.h
//  WS
//
//  Created by gwzd on 14-4-18.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *passWord;
@property (nonatomic, strong)NSString *companyName;
@property (nonatomic, strong)NSString *phoneStr;
@property (nonatomic, strong)NSString *emailStr;
@property (nonatomic, strong)NSString *project_current_Id;
@property (nonatomic, strong)NSString *project_current_name;



+(UserInfo *)shareInstance;
@end
