//
//  MessageClass.h
//  WS
//
//  Created by liuqin on 14-4-21.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageClass : NSObject

@property (nonatomic, strong)NSString *XinXi_ID;                //id
@property (nonatomic, strong)NSString *XinXi_type;           //类型
@property (nonatomic, strong)NSString *XinXi_faultid;           //反馈信息id
@property (nonatomic, strong)NSString *XinXi_faultType;       //反馈信息type
@property (nonatomic, strong)NSString *XinXi_BiaoHao;              //编号
@property (nonatomic, strong)NSString *XinXi_Biaoti;            //标题
@property (nonatomic, strong)NSString *XinXi_ZhuanYe;           //专业
@property (nonatomic, strong)NSString *XinXi_WenTiJiBie;        //问题级别
@property (nonatomic, strong)NSString *XinXi_read_state;        //阅读状态
@property (nonatomic, strong)NSString *XinXi_deal_state;        //处理状态
@property (nonatomic, strong)NSString *XinXi_FaBuShiJian;       //发布时间
@property (nonatomic, strong)NSString *XinXi_FaQiRen;           //发起人
@property (nonatomic, strong)NSString *XinXi_faqi_role;         //发起人角色
@property (nonatomic, strong)NSString *XinXi_huifu_person;      //回复人
@property (nonatomic, strong)NSString *XinXi_huifu_role;        //回复人角色
@property (nonatomic, strong)NSString *XinXi_contants;          //内容
@property (nonatomic, strong)NSString *XinXi_jianyi;         //建议
@property (nonatomic, strong)NSString *XinXi_yijian;            //意见
@property (nonatomic, strong)NSString *XinXi_result;            //结果
@property (nonatomic, strong)NSString *XinXi_result_submit;     //结果确认
@property (nonatomic, strong)NSString *XinXi_pingjia;           //评价
@property (nonatomic, strong)NSString *XinXi_forwarding;        //转发
@property (nonatomic, strong)NSString *XinXi_huifutime;         //回复时间
@property (nonatomic, strong)NSString *XinXi_proName;           //项目名称
@property (nonatomic, strong)NSString *XinXi_proid;             //项目id

@property (nonatomic, strong)NSString *XinXi_JieShouZhuanFaID;         //转发ID

@end
