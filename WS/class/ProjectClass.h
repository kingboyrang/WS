//
//  ProjectClass.h
//  WS
//
//  Created by gwzd on 14-4-15.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectClass : NSObject

@property (nonatomic, strong)NSString *pro_id;
@property (nonatomic, strong)NSString *pro_bianhao;
@property (nonatomic, strong)NSString *pro_jiancheng;
@property (nonatomic, strong)NSString *pro_quancheng;

@property (nonatomic, strong)NSString *pro_ShiFouKeYiFanKui;
@property (nonatomic, strong)NSString *WeiChuLiShuLiang;//未处理数量
@property (nonatomic, strong)NSString *WeiDuShuLiang;//未读数量

@end
