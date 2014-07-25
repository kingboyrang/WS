//
//  CKFindViewController.h
//  WS
//
//  Created by liuqin on 14-7-17.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "CKKCViewController.h"
#import "Pull_downTable.h"

@interface CKFindViewController : BaseViewController<Pull_downTableDelegate>

@property (nonatomic, strong)UIButton *btn1;
@property (nonatomic, strong)UIButton *btn2;
@property (nonatomic, strong)UITextField *textfield3;
@property (nonatomic, strong)NSMutableArray *baseDataArray;
@property (nonatomic, strong)Pull_downTable *tableView;

@property (nonatomic, strong)NSString *cangkuid;
@property (nonatomic, strong)NSString *wuliaoid;


@end
