//
//  CaoZuoClass.h
//  WS
//
//  Created by liuqin on 14-5-20.
//  Copyright (c) 2014年 刘琴. All rights reserved.



#import <Foundation/Foundation.h>

@interface CaoZuoClass : NSObject

@property (nonatomic, copy)NSString *xinxiType;
@property (nonatomic, copy)NSString *xinxiID;
@property (nonatomic, copy)NSString *fautlid;
@property (nonatomic, copy)NSString *proId;
@property (nonatomic, copy)NSString *faultType;
@property (nonatomic, copy)NSString *bianhao;
@property (nonatomic, copy)NSString *biaoti;
@property (nonatomic, copy)NSString *zhuanye;
@property (nonatomic, copy)NSString *wentijiBie;
@property (nonatomic, copy)NSString *read_state;
@property (nonatomic, copy)NSString *deal_state;
@property (nonatomic, copy)NSString *fabutime;
@property (nonatomic, copy)NSString *faqiperson;
@property (nonatomic, copy)NSString *faqirole;
@property (nonatomic, copy)NSString *huifuperson;
@property (nonatomic, copy)NSString *huifurole;
@property (nonatomic, copy)NSString *huifutime;
@property (nonatomic, copy)NSString *faultContent;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *HuiFuXuanXiang;

@property (nonatomic, readonly) CGFloat cellHeight;
@end
