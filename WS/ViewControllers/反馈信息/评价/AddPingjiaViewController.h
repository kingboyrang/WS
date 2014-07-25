//
//  AddPingjiaViewController.h
//  WS
//
//  Created by liuqin on 14-5-22.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "Pull_downTable.h"
#import "Pull_downClass.h"
#import "AppDelegate.h"



@interface AddPingjiaViewController : BaseViewController<Pull_downTableDelegate>

@property (nonatomic, strong)Pull_downTable *tableView;
@property (nonatomic, strong)NSMutableArray *jiChuArray;
@property (nonatomic, strong)UIButton *resultTypeBtn;
@property (nonatomic, strong)NSMutableString *jichuDataStr;
@property (nonatomic, strong)NSString *JieGuoIDstr;

@property (nonatomic, strong)NSMutableString *jsonData;
@property BOOL laugeEN;


@end
