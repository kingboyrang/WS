//
//  Header.h
//  WS
//
//  Created by gwzd on 14-4-2.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#ifndef WS_Header_h
#define WS_Header_h



#define ALERT(msg){    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];[alert show];}

#define USERID   @"userId"
#define USERNAME   @"userName"
#define PASSWORD   @"passWord"
#define COMPANYNAME   @"companyName"
#define PHONESTR   @"phoneStr"
#define EMAILSTR   @"emailStr"
#define PROID   @"project_current_Id"
#define PRONAME   @"project_current_name"







/*
 *信息表
      信息id，信息类型，信息标题，编号，专业，问题级别，阅读状态，处理状态，发布时间，发起人，发起人角色，回复人，回复人角色，消息概要，
      建议操作，意见操作，结果操作，结果确认操作，评价操作，转发操作 ,     反馈信息id, 项目名称，项目id, 回复时间
 *
 */
#define INFOTABLE @"INFOTABLE"

/*
 * 项目信息  
    项目id 项目简称  项目全称  项目编号
 */
#define PROJECTTABLE @"PROJECTTABLE"

/*
 *附件  
    id 类型  名称  路径  上传时间  来源   来源id
 */
#define IMAGETABLE @"IMAGETABLE"

/*
 * 项目人员信息  
   项目人员信息id   项目id 项目人员姓名
 */

#define PRO_PERSON_INFOTABLE @"PRO_PERSON_INFOTABLE"




/*
 *  
 */


#define CZTABLE @"MAINTABLE"

//(信息id text,反馈id text,类型 text,反馈类型 text,编号 text，标题 text,专业 text,问题级别 text,阅读状态 text,处理状态 text,发布时间 text,发起人 text,发起人角色 text,反馈内容 text,意见 text,建议 text,结果 text,结果确认 text,评价 text,转发 text,项目id text,项目名字

#define DETALEDTABLE @"DETAILEDTABLE"

#define ZHUANYE         @"1"
#define JIBIE           @"2"
#define GUANJIANZI      @"3"
#define RESULT          @"4"
#define RESULTSUBMITE   @"5"
#define TIXING          @"6"

#define URLHEADER   @"http://192.168.1.118/ShouHouFuWu"

#endif
